resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-ecr-repo"
  image_tag_mutability = "MUTABLE"  
  image_scanning_configuration {
    scan_on_push = true
  }
}
output "repository_url" { 
  value = aws_ecr_repository.my_ecr_repo.repository_url
}

/*
resource "aws_iam_user" "mi_usuario" {
    name = "jgl"
}
*/
resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name  # Usa "repository" en lugar de "repository_name"

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowPushPull",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::248189943700:user/jgl"
        },
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  }
  POLICY
}

resource "null_resource" "upload_image" {
  provisioner "local-exec" {
    command = <<EOT
      # Obtener el ID de cuenta de AWS usando la variable account_id
      
      aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-ecr-repo

      # Construir la imagen de Docker
      
      docker build -t 248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-ecr-repo:latest .

      # Etiquetar la imagen de Docker
      
      docker tag my-ecr-repo:latest 248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-ecr-repo:latest

      # Subir la imagen a Amazon ECR
      
      docker push 248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-ecr-repo:latest
    EOT
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Eliminar imágenes etiquetadas después de 1 días",
      "selection": {
        "tagStatus": "tagged",  
        "tagPrefixList": [
          "latest"
        ],
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
}




