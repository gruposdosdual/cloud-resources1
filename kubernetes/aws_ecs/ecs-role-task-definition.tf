resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" # Necesario para Fargate

  #  Definición de recursos a nivel de tarea
  cpu                      = "256" # Definir CPU a nivel de tarea
  memory                   = "512"  # Definir memoria a nivel de tarea

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "nginx:latest"
      memory    = 512
      cpu       = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}
