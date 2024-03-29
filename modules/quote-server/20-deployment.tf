locals {
  release = "release"
}

resource "kubernetes_deployment_v1" "quote_server_grpc" {
  metadata {
    name      = "quote-server-grpc"
    namespace = var.namespace
  }

  spec {
    # managed by Argo Rollouts (yaml/k8s/rollout.yaml)
    replicas                  = 1
    progress_deadline_seconds = 300
    revision_history_limit    = 5
    min_ready_seconds         = 20
    strategy {
      type = "RollingUpdate"

    }

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
          "app"             = "quote"
          "component"       = "server-http"
          "tier"            = "production"
          "service.name"    = "quote"
          "service.version" = var.app_version
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "8080"
          "prometheus.io/path"   = "/metrics"
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
        priority_class_name = var.priority_class

        container {
          name  = "server-http"
          image = "ghcr.io/dantulovsky/quote-server/server:${var.app_version}"
          args = [
            "--enable_metrics",
            "--version=${var.app_version}",
          ]

          port {
            name           = "http"
            container_port = var.port_http
          }

          port {
            name           = "grpc"
            container_port = var.port_grpc
          }

          env {
            name = "LS_ACCESS_TOKEN"
            value_from {
              secret_key_ref {
                # Created in the "common" module and guaranteed to exist because
                # this module depends on the "common" module.
                name     = "lightstep-access-token"
                key      = "api-key"
                optional = false
              }
            }
          }

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
              cpu    = "50m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "40Mi"
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
  }
}
