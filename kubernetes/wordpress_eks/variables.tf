variable "db_username" {
  description = "Database administrator username"
  type        = string
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}

/*
variable "create_kms_alias" {
  description = "Determines if the KMS alias should be created"
  type        = bool
  default     = true
}
*/
/*
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "wp-cluster-fjgl"
}
*/