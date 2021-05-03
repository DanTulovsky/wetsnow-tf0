
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
    annotations = {
      mesh.traefik.io/traffic-type: "http"
      mesh.traefik.io/retry-attempts: "2"
      mesh.traefik.io/ratelimit-average: "20"
      mesh.traefik.io/ratelimit-burst: "40"
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
