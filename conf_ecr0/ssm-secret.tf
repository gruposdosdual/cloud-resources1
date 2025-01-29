# Parámetro en Systems Manager Parameter Store
resource "aws_ssm_parameter" "api_key" {
  name        = "/app/api_key"
  description = "API key for the application"
  type        = "SecureString"
  value       = "my-api-key-12345" # Cambia este valor por uno real
  tags = {
    Environment = "dev"
  }
}


resource "aws_secretsmanager_secret" "app_secret" {
  name = "app/secrets"
  
  tags = {
    Environment = "dev"
  }
}

resource "aws_secretsmanager_secret_version" "app_secret_version" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = jsonencode({
    DB_PASSWORD = var.db_password
    API_KEY     = var.api_key
  })
}
/*
# Secreto en AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials"
  description = "Database credentials for the application"
  tags = {
    Environment = "dev"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin",
    password = "password123"
    host     = "mydb.example.com"
    port     = 5432
  })
}
*/