resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = "248189943700.dkr.ecr.eu-west-1.amazonaws.com/ecr-jgl:latest"
      memory    = 512
      cpu       = 256
      essential = true
      environment = [
        {
          name  = "API_KEY"
          value = "ssm:/ecs/app/api_key"
        }
      ]
      secrets = [
        {
          name      = "DB_CREDENTIALS"
          valueFrom = aws_secretsmanager_secret.db_credentials.arn
        }
      ]
    }
  ])
}
