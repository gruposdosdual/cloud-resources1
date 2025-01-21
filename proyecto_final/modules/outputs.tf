# Output de la region
# Archivo outputs.tf
output "aws_region" {
  description = "La región donde se ha desplegado la infraestructura"
  value       = var.aws_region
}


# Output de la IP pública del servidor web
output "web_server_ip" {
  description = "Public IP address of the EC2 web server"
  value       = aws_instance.web_server.public_ip
}

# Output del endpoint de la base de datos
output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = aws_db_instance.instance_db.endpoint
}
/*
# Output del endpoint de la base de datos
output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value = var.rds_engine == "mysql" ? aws_db_instance.mysql_db.endpoint : var.rds_engine == "postgresql" ? aws_db_instance.postgres_db.endpoint : null
}
*/

# Output del entorno para referencia
output "environment" {
  description = "The deployment environment (dev or prod)"
  value       = var.environment
}
