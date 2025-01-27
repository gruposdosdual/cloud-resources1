/*resource "aws_ecs_cluster" "cluster_ecs" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    #value = var.container_insight_status.disable
    value = var.container_insight_status == "enabled" ? "enabled" : "disabled"
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}
*/


provider "aws" {
  region = "eu-west-1" # Cambia la región según tus necesidades
}

variable "environment" {
  description = "El entorno de la aplicación (ej. dev, staging, prod)"
  type        = string
  default     = "dev" # Cambia el valor por defecto si es necesario
}

variable "container_insight_status" {
  description = "Estado de los insights del contenedor"
  type        = bool
  default     = false # Cambia el valor por defecto si es necesario
}

resource "aws_ecs_cluster" "fjgl_ecs" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insight_status ? "enabled" : "disabled"
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}

