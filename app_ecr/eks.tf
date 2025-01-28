/*
module "eks" {
  source              = "./modules_eks"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "eu-west-1a"
  cluster_name        = "my-eks-cluster"
  region              = "eu-west-1"
}
*/
module "eks" {
  source = "./modules_eks"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr_a  = var.public_subnet_cidr_a
  public_subnet_cidr_b  = var.public_subnet_cidr_b
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_b = var.private_subnet_cidr_b
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
  cluster_name          = var.cluster_name
}



output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
