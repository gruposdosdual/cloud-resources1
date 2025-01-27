resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

# Task Definition para Nginx
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = 256
  memory                  = 512

  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# Task Definition para Flask
resource "aws_ecs_task_definition" "flask" {
  family                   = "flask"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = 256
  memory                  = 512

  container_definitions = jsonencode([
    {
      name  = "flask"
      image = "flask-api:latest"  # Necesitarás crear esta imagen
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

# Servicio ECS para Nginx
resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = var.target_group_nginx
    container_name   = "nginx"
    container_port   = 80
  }
}

# Servicio ECS para Flask
resource "aws_ecs_service" "flask" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = var.target_group_flask
    container_name   = "flask"
    container_port   = 5000
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group" {
  description = "Security group for the ALB"
  type        = string
}

variable "target_group_nginx" {
  description = "Target group ARN for Nginx"
  type        = string
}

variable "target_group_flask" {
  description = "Target group ARN for Flask"
  type        = string
}

output "nginx_service_name" {
  value = aws_ecs_service.nginx.name
}

output "flask_service_name" {
  value = aws_ecs_service.flask.name
}
