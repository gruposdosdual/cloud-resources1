resource "aws_appautoscaling_target" "ecs_scaling" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.jgl_ecs.id}/${aws_ecs_service.nginx_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

/*
resource "aws_appautoscaling_policy" "cpu_scaling" {
  name                 = "cpu-scaling"
  scaling_target_id    = aws_appautoscaling_target.ecs_scaling.id
  policy_type          = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value        = 50
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown   = 300
    scale_out_cooldown  = 300
  }
}
*/