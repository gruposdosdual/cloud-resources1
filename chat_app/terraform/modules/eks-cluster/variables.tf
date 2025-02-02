variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
