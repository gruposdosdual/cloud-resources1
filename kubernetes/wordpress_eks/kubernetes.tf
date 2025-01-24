provider "kubernetes" {
    config_path = "/home/javier/.kube/config"
    #config_context = "mi-cluster-fjgl"  # Nombre del contexto del clúster
}



resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      App = "wordpress"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          App = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress:latest"
          name  = "wordpress"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = aws_db_instance.wordpress.endpoint
          }
          
          env {
            name  = "WORDPRESS_DB_USER"
            value = var.db_username
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = var.db_password
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress-service"
  }

  spec {
    selector = {
      App = kubernetes_deployment.wordpress.spec[0].template[0].metadata[0].labels.App
      #App = kubernetes_deployment.wordpress.spec.template.metadata.labels.App
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}