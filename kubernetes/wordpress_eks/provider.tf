provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.wordpress.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.wordpress.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.wordpress.token
}