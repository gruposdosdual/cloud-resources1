resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx_autoscaler" {
  metadata {
    name = "nginx-hpa"
  }

  spec {
    max_replicas = 10
    min_replicas = 2

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                  = "Utilization"
          average_utilization   = 50
        }
      }
    }
  }
}


