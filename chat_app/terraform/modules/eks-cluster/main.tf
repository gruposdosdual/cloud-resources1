resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
