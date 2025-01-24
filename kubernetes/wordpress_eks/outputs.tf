# Archivo outputs.tf
output "eks_cluster_name" {
  #value = aws_eks_cluster.wordpress.name
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  #value = aws_eks_cluster.wordpress.endpoint
  value = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  #value = aws_eks_cluster.wordpress.arn
  value = module.eks.cluster_arn
}

output "rds_endpoint" {
  value = aws_db_instance.wordpress.endpoint
}

/*
output "wordpress_service_url" {
  #value = kubernetes_service.wordpress.status.load_balancer.ingress[0].hostname
  # Caso servicio aun no tenga la IP o URL asignada
  #value = length(kubernetes_service.wordpress.status[0].load_balancer.ingress) > 0 ? kubernetes_service.wordpress.status[0].load_balancer.ingress[0].hostname : null
  #value = kubernetes_service.wordpress.status[0].load_balancer.ingress[0].hostname
  value = kubernetes_service.wordpress.status.load_balancer[0].ingress[0].hostname
}
*/