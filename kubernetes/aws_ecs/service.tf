resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.fjgl_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-03f5b0dc5550de2c4", "subnet-0ece7ad592169689c"] # Reemplaza con tus subredes
    security_groups  = ["sg-00e8eb67023bed9ef"] # Reemplaza con tu grupo de seguridad
    assign_public_ip = true
  }
}










/*
 # Obtener la IP pública de la tarea
resource "aws_network_interface" "nginx_network_interface" {
  count = aws_ecs_service.nginx_service.network_configuration[0].assign_public_ip ? 1 : 0

  subnet_id   = "subnet-03f5b0dc5550de2c4" # Reemplaza con tu subred
  security_groups = ["sg-00e8eb67023bed9ef"] # Reemplaza con tu grupo de seguridad

  attachment {
    instance = aws_ecs_service.nginx_service.id
  }
}

output "nginx_service_public_ip" {
  value = aws_network_interface.nginx_network_interface[0].private_ip
}

/*
 # Obtener la IP pública de la tarea
data "aws_ecs_task_definition" "nginx_task" {
  cluster = aws_ecs_cluster.fjgl_ecs.id
  task_id = aws_ecs_service.nginx_service.task_definition
}

output "nginx_service_public_ip" {
  value = data.aws_ecs_task.nginx_task.network_interfaces[0].private_ip
}
*/
