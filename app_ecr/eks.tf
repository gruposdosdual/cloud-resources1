module "eks" {
  source              = "modules/eks"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "eu-west-1a"
  cluster_name        = "my-eks-cluster"
  region              = "eu-west-1"
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
