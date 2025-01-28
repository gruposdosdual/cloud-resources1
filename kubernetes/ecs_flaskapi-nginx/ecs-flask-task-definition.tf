resource "aws_ecs_task_definition" "flask_task" {
  family                = "flask-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"
  container_definitions = jsonencode([{
    name      = "flask-container"
    image     = "flask:latest"  # Cambia esto por la imagen de tu API Flask
    cpu       = 256
    memory    = 512
    portMappings = [{
      containerPort = 5000
    }]
  }])
}
