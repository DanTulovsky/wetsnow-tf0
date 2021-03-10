resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}

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

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "static-web"

        component = "frontend"

        tier = "production"
      }
    }

    template {
      metadata {
        labels = {
          app = "static-web"

          component = "frontend"

          tier = "production"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "ghcr.io/dantulovsky/web-static/frontend"
          args  = ["--data_dir", "/data/hosts", "--enable_logging", "--enable_tracing"]

          port {
            name           = "http"
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "20Mi"
            }

            requests {
              cpu    = "100m"
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
