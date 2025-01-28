# Crear un repositorio ECR
resource "aws_ecr_repository" "ecr-jgl" {
  name = "ecr-jgl"

  tags = {
    Name        = "ecr-jgl"
    Environment = "dev"
  }
}


# Configurar una Política de Ciclo de Vida para el Repositorio
resource "aws_ecr_lifecycle_policy" "my_lifecycle_policy" {
    repository = aws_ecr_repository.ecr-jgl.name
  
    policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Retain only 5 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}