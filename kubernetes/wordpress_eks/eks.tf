provider "aws" {
  region = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  # Habilita la clave KMS si es necesario
  create_kms_key = true

  cluster_name    = "mi-cluster-fjgl"
  cluster_version = "1.31"

  #vpc_id     = "vpc-0e153281ba273a18c"
  vpc_id     = "vpc-002427d5be38383d7"
  subnet_ids = ["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
  #subnet_ids = ["ssubnet-0ed7f58c541c284ee", "subnet-03e43c39b3e2b6adc"]
  #subnet_ids = ["subnet-0ca2066e2d5f1a1cd", "subnet-03e43c39b3e2b6adc"]

  eks_managed_node_groups = {
    wordpress-nodes = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
      
      

      instance_types = ["t3.small"]
    }
  }
}


