# Parámetro en Systems Manager Parameter Store
resource "aws_ssm_parameter" "api_key" {
  name        = "/ecs/app/api_key"
  description = "API key for the application"
  type        = "SecureString"
  value       = "my-api-key-12345" # Cambia este valor por uno real
  tags = {
    Environment = var.environment
  }
}

# Secreto en AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials"
  description = "Database credentials for the application"
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin",
    password = "supersecurepassword123"
  })
}
