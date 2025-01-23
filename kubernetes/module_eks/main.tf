provider "aws" {
  region = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "mi-cluster-jgl"
  cluster_version = "1.27"

  vpc_id     = "vpc-0e153281ba273a18c"
  subnet_ids = ["subnet-0ca2066e2d5f1a1cd", "subnet-03e43c39b3e2b6adc"]

  eks_managed_node_groups = {
    mi-nodo-grupo = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
    }
  }
}