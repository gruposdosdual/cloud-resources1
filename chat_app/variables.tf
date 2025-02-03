variable "aws_region" {
  description = "AWS region to deploy infrastructure"
  type        = string
  default     = "eu-west-1"
}
/*
variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token"
  type        = string
  sensitive   = true
  default     = ""
}
*/
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
