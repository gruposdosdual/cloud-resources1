variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "La región de AWS"
  default     = "eu-west-1"
}

variable "repository_name" {
  description = "El nombre del repositorio ECR"
  default     = "my-ecr-repo"
}
