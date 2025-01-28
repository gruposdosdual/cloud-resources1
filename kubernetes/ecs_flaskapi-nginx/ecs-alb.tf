resource "aws_lb" "ejemplo-alb" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_security_group.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  enable_deletion_protection = false


tags = {
    Name = "example-alb"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "nginx_targets" {
  name     = "nginx-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

resource "aws_lb_target_group" "flask_targets" {
  name     = "flask-targets"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ejemplo-alb.arn
  port              = "80"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code = 200
      message_body = "OK"
    }
  }

  # Enrutamiento de tráfico a Nginx
  dynamic "default_action" {
    for_each = aws_ecs_service.nginx_service
    content {
      type = "forward"
      target_group_arn = aws_lb_target_group.nginx_targets.arn
    }
  }
  
  # Enrutamiento de tráfico a Flask
  dynamic "default_action" {
    for_each = aws_ecs_service.flask_service
    content {
      type = "forward"
      target_group_arn = aws_lb_target_group.flask_targets.arn
    }
  }
}
