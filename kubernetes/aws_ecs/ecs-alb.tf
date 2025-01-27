resource "aws_lb" "fjgl_alb" {
  name               = "faeclss-ealb-fjgl"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]   # ["sg-00e8eb67023bed9ef"] # Reemplaza con tu grupo de seguridad
  subnets            = ["subnet-03f5b0dc5550de2c4", "subnet-0ece7ad592169689c"] # Reemplaza con tus subredes

  tags = {
    Name        = "faeclss-ealb-fjgl"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "ecs_targets" {
  name     = "ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0aad847febf809cf4"#aws_vpc.default.id # Asegúrate de que aws_vpc.default esté definido en tu configuración

  target_type = "ip"

  health_check {
  enabled             = true
  healthy_threshold   = 2
  interval            = 30
  matcher            = "200"
  path               = "/"
  port               = "traffic-port"
  protocol           = "HTTP"
  timeout            = 5
  unhealthy_threshold = 2
  }

  tags = {
    Name        = "ecs-targets"
    Environment = "production"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.fjgl_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.ecs_targets.arn
    
  }
}


resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.fjgl_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-03f5b0dc5550de2c4", "subnet-0ece7ad592169689c"] # Reemplaza con tus subredes
    security_groups  = [aws_security_group.alb_sg.id] #["sg-00e8eb67023bed9ef"] # Reemplaza con tu grupo de seguridad
    assign_public_ip = true
  
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets.arn
    container_name   = "nginx-container" # Asegúrate de que este nombre coincida con el nombre del contenedor en tu definición de tarea
    container_port   = 80
  }


# Asegúrate de que el servicio esté configurado para usar el ALB
  depends_on = [aws_lb_listener.http_listener]  # Asegúrate de que el listener esté creado antes de crear el servicio

  tags = {
    Name        = "nginx-service"
    Environment = "production"
  }
}