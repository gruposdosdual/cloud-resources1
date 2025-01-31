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
