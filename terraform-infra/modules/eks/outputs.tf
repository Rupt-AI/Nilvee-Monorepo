# ==============================================================================
# SUBMODULE COMPLIANCE: EXPOSE CORE IAM IDENTITIES TO ROOT STATE
# ==============================================================================

output "cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "The physical network URL endpoint utilized to access the managed EKS control plane API."
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "The programmatic IAM Amazon Resource Name utilized for passwordless GitHub pipelines authentication."
}

output "eso_iam_role_arn" {
  value       = aws_iam_role.eso_role.arn
  description = "The specific IAM Amazon Resource Name utilized by the internal External Secrets Operator token swap."
}
