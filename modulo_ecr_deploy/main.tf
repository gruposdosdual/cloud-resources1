provider "aws" {
  region = "eu-west-1"
  profile = "248189943700_EKS-alumnos"
}



resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"  # O "IMMUTABLE" según tus necesidades
  tags = {
    Name = var.repository_name
  }
}

