resource "aws_ecr_repository" "this" {
  name = "chat-app"
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository_name = aws_ecr_repository.this.name
  policy          = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 30 days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
