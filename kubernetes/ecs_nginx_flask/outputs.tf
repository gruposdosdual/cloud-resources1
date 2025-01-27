output "nginx_url" {
  value = "http://${module.alb.alb_dns_name}/"
}

output "flask_url" {
  value = "http://${module.alb.alb_dns_name}/api/hello"
}
