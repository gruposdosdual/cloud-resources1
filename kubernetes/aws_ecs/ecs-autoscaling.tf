# Auto Scaling Target para ECS
resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id       = "service/${aws_ecs_cluster.fjgl_ecs.name}/${aws_ecs_service.nginx_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity      = 1
  max_capacity      = 5
}

# Política de Auto Scaling basada en CPU
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "cpu-auto-scaling"
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 50.0
    scale_in_cooldown  = 300  # 5 minutos
    scale_out_cooldown = 300  # 5 minutos
  }
}

# Política de Auto Scaling basada en Memoria
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "memory-auto-scaling"
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 50.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Alertas de CloudWatch para monitoreo
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "ecs-cpu-high-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period             = "300"
  statistic          = "Average"
  threshold          = "85"
  alarm_description  = "This metric monitors ECS CPU utilization"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.fjgl_ecs.name
    ServiceName = aws_ecs_service.nginx_service.name
  }

  alarm_actions = [] # Aquí puedes agregar ARNs de SNS topics para notificaciones
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "ecs-memory-high-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period             = "300"
  statistic          = "Average"
  threshold          = "85"
  alarm_description  = "This metric monitors ECS Memory utilization"
  
  dimensions = {
    ClusterName = aws_ecs_cluster.fjgl_ecs.name
    ServiceName = aws_ecs_service.nginx_service.name
  }

  alarm_actions = [] # Aquí puedes agregar ARNs de SNS topics para notificaciones
}