output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_1_id" {
  description = "ID de la primera subred pública"
  value       = aws_subnet.subnet_1.id
}

output "subnet_2_id" {
  description = "ID de la segunda subred pública"
  value       = aws_subnet.subnet_2.id
}

output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  value       = aws_db_instance.rds.endpoint
}

output "ecs_cluster_id" {
  description = "ID del cluster ECS"
  value       = aws_ecs_cluster.ecs_cluster.id
}

/*
output "alb_dns_name" {
  description = "DNS público del ALB"
  value       = aws_lb.ecs_alb.dns_name
}
*/