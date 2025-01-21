variable "aws_region" {
  description = "Región de AWS para la implementación"
  type        = string
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  #default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for the environment"
  type        = string
  
}

variable "ami_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  #default     = "t2.micro"
}

variable "rds_engine" {
  description = "RDS engine type (mysql or postgresql)"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

# ---------------------------------------------------------##











