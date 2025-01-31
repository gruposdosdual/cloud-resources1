module "vpc" {
  source = "./modules/vpc"

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
  source = "./modules/eks-cluster"
  cluster_name = var.cluster_name
  region       = var.aws_region
}

module "eks_node_group" {
  source = "./modules/eks-node-group"
  cluster_name = module.eks_cluster.cluster_name
  node_group_name = var.node_group_name
  region = var.aws_region
}

module "alb" {
  source = "./modules/alb"
  region = var.aws_region
  cluster_name = module.eks_cluster.cluster_name
}

module "ecr" {
  source = "./modules/ecr"
  region = var.aws_region
}

module "iam_roles" {
  source = "./modules/iam-roles"
  region = var.aws_region
}
