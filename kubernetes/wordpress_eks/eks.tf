provider "aws" {
  region = "eu-west-1"
  profile = "248189943700_EKS-alumnos"
}


# Crear cluster eks
resource "aws_eks_cluster" "wordpress" {
  name     = var.cluster_name
  version  = "1.32"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = var.public_subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

# Crear un grupo de nodos

resource "aws_eks_node_group" "wordpress" {
  cluster_name    = aws_eks_cluster.wordpress.name
  node_group_name = "wordpress-nodes-jgl"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}


/*
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0" 


  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  
  vpc_id      = var.vpc_id

  #public_subnet_ids = var.public_subnet_ids

  

  eks_managed_node_groups = {
    wordpress-nodes = {
      desired_size = 2
      max_size     = 3
      min_size     = 1   
      

      instance_types = ["t3.small"]
    }
  }
}
*/

