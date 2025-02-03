terraform {
  backend "s3" {
    bucket         = "mi-terraform-tfstate-248189943700"  # Nombre del bucket S3
    key            = "terraform/state/terraform.tfstate"  # Ruta dentro del bucket
    region         = "eu-west-1"  # Región de AWS
    encrypt        = true  # Cifrado en el bucket S3
    #dynamodb_table = "terraform-lock"  # Tabla DynamoDB para bloqueo
  }
}



module "vpc" {
  source = "./terraform/modules/vpc"

  cidr_block                = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones        = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cluster_name              = "chat-app-cluster"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "security_group_id" {
  value = module.vpc.security_group_id
}




module "eks_cluster" {
  source = "./terraform/modules/eks-cluster"
  cluster_name = var.cluster_name  

  # Obtiene las subnets del módulo de VPC
  subnet_ids = module.vpc.private_subnet_ids

  # Obtiene el rol de IAM del módulo correspondiente
  iam_role_arn = module.iam_roles.cluster_role_arn
}

module "eks_node_group" {
  source = "./terraform/modules/eks-node-group"
  cluster_name = module.eks_cluster.cluster_name

  # Obtiene las subnets desde el módulo VPC
  subnet_ids = module.vpc.private_subnet_ids

   # Obtiene el rol de IAM del módulo IAM
  node_role_arn = module.iam_roles.node_role_arn

  node_group_name = "chat-app-nodes"  #var.node_group_name 
  
}

module "alb" {
  source = "./terraform/modules/alb"  
  cluster_name = module.eks_cluster.cluster_name
  
  # Obtiene la VPC desde el módulo de VPC
  vpc_id = module.vpc.vpc_id

  # Obtiene las subnets públicas de la VPC
  subnets = module.vpc.public_subnet_ids

  # Obtiene los grupos de seguridad adecuados
  security_groups = [module.vpc.security_group_id]  #[module.security_group.alb_sg_id]

}

module "ecr" {
  source = "./terraform/modules/ecr"
  region = var.aws_region
}

module "iam_roles" {
  source = "./terraform/modules/iam-roles"

  role_name = "chat-app-eks-role" #var.aws_iam_role.role_name  
}
