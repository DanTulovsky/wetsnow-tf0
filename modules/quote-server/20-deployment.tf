locals {
  release = "release"
}

resource "kubernetes_deployment" "quote_server_http" {
  metadata {
    name      = "quote-server-http"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "quote"
        component = "server-http"
        tier      = "production"
      }
    }

    template {
      metadata {
        labels = {
          app       = "quote"
          component = "server-http"
          tier      = "production"
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
          max_skew           = 2
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "DoNotSchedule"
          label_selector {
            match_labels = {
              app       = "quote"
              component = "server-http"
              tier      = "production"
            }
          }
        }
        # topology_spread_constraint {
        #   max_skew           = 1
        #   topology_key       = "kubernetes.io/hostname"
        #   when_unsatisfiable = "DoNotSchedule"
        #   label_selector {
        #     match_labels = {
        #       app       = "quote"
        #       component = "server-http"
        #       tier      = "production"
        #     }
        #   }
        # }
        container {
          name  = "server-http"
          image = "ghcr.io/dantulovsky/quote-server/server:${var.app_version}"
          args  = ["--enable_metrics", "--version=${var.app_version}"]

          port {
            name           = "http"
            container_port = var.port_http
          }

          env {
            name  = "LS_ACCESS_TOKEN"
            value = var.lightstep_access_token
          }

          # env {
          #   name  = "LS_SERVICE_VERSION"
          #   value = var.app_version
          # }

          env {
            name  = "PORT"
            value = var.port_http
          }

          env {
            name  = "GIN_MODE"
            value = local.release
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "100Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = var.port_http

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
              port = var.port_http

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
