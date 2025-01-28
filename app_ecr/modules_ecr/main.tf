resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my_app_repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "app-ecr-repo"
    Environment = "dev"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowEKSNodeAccess",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "${var.account_id}"
          }
        }
      }
    ]
  }
  POLICY
}
