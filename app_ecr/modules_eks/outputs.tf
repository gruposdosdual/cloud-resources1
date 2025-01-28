output "cluster_endpoint" {
  value = aws_eks_cluster.my_eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.my_eks_cluster.name
}
