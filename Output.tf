output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The URL endpoint utilized by administration tooling and pipelines to access the live EKS API plane."
}

output "github_actions_role_arn" {
  value       = module.eks.github_actions_role_arn
  description = "The exact IAM Role ARN assigned for passwordless GitHub Actions OpenID Connect federation."
}

output "eso_iam_role_arn" {
  value       = module.eks.eso_iam_role_arn
  description = "The specific IAM Role ARN assigned for the internal External Secrets Operator cloud token handshake."
}
