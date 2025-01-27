variable "region" {
  default = "eu-west-1"
}

variable "environment" {
  description = "El entorno de la infraestructura"
  type        = string
  default     = "dev"  # Puedes cambiar esto según tu entorno
}

variable "container_insight_status" {
  description = "Estado de los container insights"
  type        = object({
    disable = string
  })
  default = {
    disable = "false"
  }
}



/*
variable "cluster_name" {
  description = "Cluster name"
}



variable "db_username" {
  description = "Database administrator username"
  type        = string
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID for resources"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}


variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}

*/

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