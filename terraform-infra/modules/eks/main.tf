# ==============================================================================
# PHASE 1 COMPLETE COMPUTE ENGINE & STORAGE CLASS ATTACHMENT
# ==============================================================================

variable "cluster_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }

# 1. IAM Role for EKS Control Plane
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-control-plane-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "://amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# 2. Managed EKS Cluster Control Plane Core
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.30"

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# 3. OIDC Provider Configuration for IRSA
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity.oidc.issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["://amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates.sha1_fingerprint]
  url             = aws_eks_cluster.main.identity.oidc.issuer
}

# 4. IAM Role for Managed Worker Nodes
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-worker-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "://amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.nodes.name
  policy_arn = each.value
}

# 5. Managed Elastic Node Groups
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "production-ha-workers"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 10
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"

  depends_on = [aws_iam_role_policy_attachment.node_policies]
}

# 6. AWS EBS CSI Driver Add-On Engine (Prevents Persistent Volume Mounting Deadlocks)
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.30.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn

  tags = {
    Component = "StorageController"
    Layer     = "Infrastructure"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "ebs_csi_role" {
  name = "${var.cluster_name}-ebs-csi-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role.name
}

# 7. Federated Identity Provider for GitHub Actions (Passwordless OIDC Pipeline Authentication)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://githubusercontent.com"
  client_id_list  = ["://amazonaws.com"]
  thumbprint_list = ["1c587768f3d307e6203a3188e4006c76c1a84f33"]
}

resource "aws_iam_role" "github_actions_role" {
  name = "${var.cluster_name}-github-actions-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = { "://githubusercontent.com:aud" = "://amazonaws.com" }
        StringLike   = { "://githubusercontent.com:sub" = "repo:Rupt-AI/Nilvee-Monorepo:*" }
      }
    }]
  })
}

# 8. External Secrets Operator IAM Sync Platform Controls
resource "aws_iam_role" "eso_role" {
  name = "${var.cluster_name}-eso-cloud-vault-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.eks.arn }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = { StringEquals = { "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:external-secrets:secret-operator" } }
    }]
  })
}

resource "aws_iam_policy" "eso_policy" {
  name = "${var.cluster_name}-eso-secrets-manager-read-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"], Resource = "arn:aws:secretsmanager:*:*:secret:production/*" }]
  })
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.eso_policy.arn
}
