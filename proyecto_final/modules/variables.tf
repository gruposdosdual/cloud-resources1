variable "aws_region" {
  description = "Región de AWS para la implementación"
  type        = string
  default     = "eu-west-3"
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for the environment"
  type        = string
  default     = "ami-09be70e689bddcef5"  # Este es un ejemplo, cámbialo por la AMI correcta para tu entorno
  
}

variable "ami_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.small"
}

variable "rds_engine" {
  description = "RDS engine type (mysql or postgresql)"
  type        = string
  default     = "mysql"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

# ---------------------------------------------------------##











