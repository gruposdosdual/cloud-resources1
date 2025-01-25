provider "aws" {
  region = var.region
  #shared_credentials_files = "~/.aws/credentials"
  #shared_config_files = ["~/.aws/config"]
  profile = "248189943700_EKS-alumnos"
}

provider "kubernetes" {
    config_path = "/home/javier/.kube/config"
    #config_context = "mi-cluster-fjgl"  # Nombre del contexto del clúster
}

/*
provider "aws" {
  region = var.region
  profile = "248189943700_EKS-alumnos"
}
*/
/*
provider "kubernetes" {
  host                   = aws_eks_cluster.wordpress.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.wordpress.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.wordpress.token
}
*/

