resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
  }

  spec {
    replicas                  = 1
    progress_deadline_seconds = 300

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
          "app"       = "static-web"
          "component" = "frontend"
          "tier"      = "production"
          "service.name" = "web-static"
          "service.version" = "${var.app_version}"
        }
      }

      spec {
        share_process_namespace = true
        toleration {
          key      = "node-role.kubernetes.io/master"
          effect   = "NoSchedule"
          operator = "Exists"
        }
        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "DoNotSchedule"
          label_selector {
            match_labels = {
              app       = "static-web"
              component = "frontend"
              tier      = "production"
            }
          }
        }
        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "DoNotSchedule"
          label_selector {
            match_labels = {
              app       = "static-web"
              component = "frontend"
              tier      = "production"
            }
          }
        }
        container {
          name  = "frontend"
          image = "ghcr.io/dantulovsky/web-static/frontend:${var.app_version}"
          args = [
            "--data_dir",
            "/data/hosts",
            "--enable_logging",
            "--enable_metrics",
            "--version=${var.app_version}",
            "--enable_kafka=false",
            "--kafka_broker=kafka0.kafka",
            "--quote_server=http://quote-server-http.web:8080"
          ]

          port {
            name           = "http"
            container_port = 8080
          }

          env {
            name  = "LS_ACCESS_TOKEN"
            value = var.lightstep_access_token
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "200Mi"
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
