variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "eu-west-1"
}

variable "profile" {
  description = "Perfil de AWS CLI a utilizar"
  type        = string
  default     = "248189943700_EKS-alumnos"
}

variable "vpc_cidr" {
  description = "CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  description = "CIDR para la primera subred pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "CIDR para la segunda subred pública"
  type        = string
  default     = "10.0.3.0/24"
}

variable "rds_subnet_1_cidr" {
  description = "CIDR para la primera subred privada de RDS"
  type        = string
  default     = "10.0.4.0/24"
}

variable "rds_subnet_2_cidr" {
  description = "CIDR para la segunda subred privada de RDS"
  type        = string
  default     = "10.0.5.0/24"
}

variable "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  type        = string
  default     = "xxx-ecs-cluster"
}

variable "ecs_task_family" {
  description = "Nombre de la tarea ECS"
  type        = string
  default     = "my-task"
}

variable "container_name" {
  description = "Nombre del contenedor dentro de la tarea"
  type        = string
  default     = "my-container"
}

variable "container_image" {
  description = "Imagen del contenedor a desplegar en ECS"
  type        = string
  default     = "248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-repo:latest"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "mydb"
}

variable "db_engine" {
  description = "Motor de base de datos"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Versión del motor de base de datos"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_secret_name" {
  description = "Nombre del secreto en AWS Secrets Manager"
  type        = string
  default     = "my-db-credentials"
}
