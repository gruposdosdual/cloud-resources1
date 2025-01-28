variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "app-ecr-repo"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}
