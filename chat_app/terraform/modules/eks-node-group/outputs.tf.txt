variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS Node Group name"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the Node Group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
