variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "ecr-jgl"
}

variable "api_key" {
  description = "API Key for the application"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}