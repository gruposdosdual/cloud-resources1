output "repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}
