variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS geographic region where all core infrastructure nodes will be provisioned."
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "The target region variable must adhere to a valid AWS string layout scheme (e.g., us-east-1)."
  }
}

variable "environment" {
  type        = string
  default     = "production"
  description = "The target environment configuration profile string tier layout."
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "The target environment configuration variable type scope must strictly evaluate to development, staging, or production."
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The isolated network core block size allocations for the VPC network perimeter boundary."
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The structural vpc_cidr parameter must define a mathematically valid IPv4 CIDR allocation string block format."
  }
}

variable "cluster_name" {
  type        = string
  default     = "prod-enterprise-cluster"
  description = "The exact alphanumeric identification token string bound to the EKS Kubernetes control plane server nodes."
}
