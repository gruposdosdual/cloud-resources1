resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    # Tipo LoadBalancer para exponer el servicio fuera del clúster
    type = "LoadBalancer"
  }
}
