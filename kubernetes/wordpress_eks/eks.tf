provider "aws" {
  region = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0" 


  cluster_name    = "mi-cluster-fjgl"
  cluster_version = "1.31"

  #vpc_id     = "vpc-0e153281ba273a18c"
  vpc_id     = "vpc-002427d5be38383d7"
  subnet_ids = ["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
  #subnet_ids = ["ssubnet-0ed7f58c541c284ee", "subnet-03e43c39b3e2b6adc"]
  #subnet_ids = ["subnet-0ca2066e2d5f1a1cd", "subnet-03e43c39b3e2b6adc"]

  # Habilita la clave KMS si es necesario
  #create_kms_key = false
  
  # Configuración de cifrado KMS
  cluster_encryption_config = {
    enable = true
    resources = ["secrets"]  # Puedes añadir "secrets" o "all" según lo que necesites
    key_id = "arn:aws:kms:eu-west-3:248189943700:key/c5d25024-825f-424e-b375-92d326239d32"
  }

  # Usa el alias KMS existente
  #kms_key_id = "arn:aws:kms:eu-west-3:248189943700:key/c5d25024-825f-424e-b375-92d326239d32"

  # Habilita el cifrado KMS con la clave especificada
  /*
  cluster_encryption_config = {
    enable = true
    key_id = "arn:aws:kms:eu-west-3:248189943700:key/c5d25024-825f-424e-b375-92d326239d32"
  }
  */

  eks_managed_node_groups = {
    wordpress-nodes = {
      desired_size = 2
      max_size     = 3
      min_size     = 1   
      

      instance_types = ["t3.small"]
    }
  }
}


