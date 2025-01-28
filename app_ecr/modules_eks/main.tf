resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "my_subnet_public_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr_a
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "my_subnet_public_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr_b
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true
}

resource "aws_subnet" "my_subnet_private_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = var.availability_zone_a
}

resource "aws_subnet" "my_subnet_private_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = var.availability_zone_b
}

resource "aws_security_group" "eks_security_group" {
  name_prefix = "eks-sg"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_eks_cluster" "my_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  
  vpc_config {
    subnet_ids = [
      aws_subnet.my_subnet_private_a.id,
      aws_subnet.my_subnet_private_b.id
    ]
  }
}


resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.my_subnet_public_a.id,
    aws_subnet.my_subnet_public_b.id
  ]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}
