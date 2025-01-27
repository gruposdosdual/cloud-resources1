resource "aws_ecs_cluster" "cluster_ecs" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insight_status.disable
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}
