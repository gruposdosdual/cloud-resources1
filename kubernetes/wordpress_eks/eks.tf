provider "aws" {
  region = "eu-west-1"
  profile = "248189943700_EKS-alumnos"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0" 


  cluster_name    = "mi-cluster-fjgl-v3"
  cluster_version = "1.31"

  
  vpc_id      = "vpc-0aad847febf809cf4"

  subnet_ids =["subnet-03f5b0dc5550de2c4", "subnet-0ece7ad592169689c", "subnet-0de031bfa5831cae1"]

  

  eks_managed_node_groups = {
    wordpress-nodes = {
      desired_size = 2
      max_size     = 3
      min_size     = 1   
      

      instance_types = ["t3.small"]
    }
  }
}


