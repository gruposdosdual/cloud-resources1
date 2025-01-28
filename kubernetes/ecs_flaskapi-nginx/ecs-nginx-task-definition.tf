resource "aws_ecs_task_definition" "nginx_task" {
  family                = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"
  container_definitions = jsonencode([{
    name      = "nginx-container"
    image     = "nginx:latest"
    cpu       = 256
    memory    = 512
    portMappings = [{
      containerPort = 80
    }]
  }])
}
