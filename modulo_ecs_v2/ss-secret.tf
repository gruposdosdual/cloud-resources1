resource "aws_secretsmanager_secret" "db_secret" {
  name = "my-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "password123"
  })
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_secret.id
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_secrets_policy" {
  name        = "ecsSecretsPolicy-${random_string.suffix.result}"
  description = "Allow ECS tasks to access Secrets Manager"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Resource = aws_secretsmanager_secret.db_secret.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_secrets_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_policy.arn
}

resource "aws_iam_policy" "application_autoscaling_policy" {
  name        = "ApplicationAutoScalingPolicy"
  description = "Policy to allow Application Auto Scaling actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:PutScalingPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_application_autoscaling_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name  # Cambia esto si usas otro rol
  policy_arn = aws_iam_policy.application_autoscaling_policy.arn
}

/*
resource "aws_iam_role_policy_attachment" "attach_application_autoscaling_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name  # Cambia esto si usas otro rol
  policy_arn = aws_iam_policy.application_autoscaling_policy.arn
}
*/


/*
# Nueva política para Auto Scaling
resource "aws_iam_policy" "autoscaling_policy" {
  name        = "ECSAutoScalingPolicy-${random_string.suffix.result}"
  description = "Policy that allows auto scaling of ECS services"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "application-autoscaling:*",
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
        ]
        Resource = "*"
      }
    ]
  })
}

# Rol específico para Auto Scaling
resource "aws_iam_role" "autoscaling_role" {
  name = "ECSAutoScalingRole-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Adjuntar la política de Auto Scaling al rol
resource "aws_iam_role_policy_attachment" "autoscaling_policy_attach" {
  role       = aws_iam_role.autoscaling_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}
*/