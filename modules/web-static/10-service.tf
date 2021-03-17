
resource "kubernetes_service" "static_web_frontend" {
  metadata {
    name      = "static-web-frontend"
    namespace = var.namespace

    labels = {
      app       = "static-web"
      component = "frontend"
      service   = "static-web-frontend"
      tier      = "production"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = "http"
    }

    selector = {
      app       = "static-web"
      component = "frontend"
      tier      = "production"
    }

    cluster_ip       = "None"
    type             = "ClusterIP"
    session_affinity = "None"
  }
}
