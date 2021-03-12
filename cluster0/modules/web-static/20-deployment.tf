resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "static-web"
        component = "frontend"
        tier      = "production"
      }
    }

    template {
      metadata {
        labels = {
          app       = "static-web"
          component = "frontend"
          tier      = "production"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "ghcr.io/dantulovsky/web-static/frontend:${var.app_version}"
          args  = ["--data_dir", "/data/hosts", "--enable_logging", "--enable_tracing", "--version=${var.app_version}", "--kafka_broker=kafka0.kafka"]

          port {
            name           = "http"
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "50m"
              memory = "20Mi"
            }

            requests {
              cpu    = "50m"
              memory = "20Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"

              http_header {
                name  = "X-Healthz-Prober"
                value = "liveliness"
              }
            }

            initial_delay_seconds = 5
            period_seconds        = 5
          }

          readiness_probe {
            http_get {
              path = "/servez"
              port = "8080"

              http_header {
                name  = "X-Healthz-Prober"
                value = "readiness"
              }
            }

            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}
