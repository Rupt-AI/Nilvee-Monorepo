# ==============================================================================
# REMEDIATION: SHARED ROOT REGISTRY (Safely references module attributes)
# ==============================================================================

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The verified URL utilized by administrative pipelines to control the live EKS API plane."
}

output "github_actions_role_arn" {
  value       = module.eks.github_actions_role_arn
  description = "The explicit IAM Role Amazon Resource Name mapped for passwordless OIDC token swapping workflows."
}

output "eso_iam_role_arn" {
  value       = module.eks.eso_iam_role_arn
  description = "The secure IAM Role Amazon Resource Name leveraged by the internal Secrets Operator cluster engine."
}

