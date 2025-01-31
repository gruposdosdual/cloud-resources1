variable "aws_region" {
  description = "AWS region to deploy infrastructure"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "chat-app-cluster"
}

variable "node_group_name" {
  description = "EKS Node Group name"
  type        = string
  default     = "chat-app-node-group"
}

# Add other variables as needed for ECR, ALB, etc.
