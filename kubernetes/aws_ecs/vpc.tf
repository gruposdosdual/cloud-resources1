# Security Group para el ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = "vpc-0aad847febf809cf4"  # Usa el mismo VPC ID que tienes en tu configuración

  # Regla de entrada - Permite todo el tráfico HTTP desde cualquier lugar
  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Regla de salida - Permite todo el tráfico saliente
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# Security Group para las tareas ECS
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs-tasks-security-group"
  description = "Security group for ECS tasks"
  vpc_id      = "vpc-0aad847febf809cf4"

  # Regla de entrada - Permite tráfico HTTP solo desde el ALB
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Regla de salida - Permite todo el tráfico saliente (necesario para pulls de imagen, etc.)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ecs-tasks-security-group"
  }
}