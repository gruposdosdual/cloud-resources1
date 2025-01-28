resource "aws_ecs_cluster" "jgl_ecs" {
  name = "${var.environment}-cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insight_status
  }
  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}
