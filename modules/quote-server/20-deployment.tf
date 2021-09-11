locals {
  release = "release"
}

resource "kubernetes_deployment" "quote_server_http" {
  metadata {
    name      = "quote-server-http"
    namespace = var.namespace
  }

  spec {
    # managed by Argo Rollouts (yaml/k8s/rollout.yaml)
    replicas                  = 0
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

        init_container {
          # traffic director required bootstrap file
          name = "grpc-td-init"
          args = [
            "--output",
            "/tmp/bootstrap/td-grpc-bootstrap.json"
          ]
          image           = "gcr.io/trafficdirector-prod/td-grpc-bootstrap:0.11.0"
          imagePullPolicy = "IfNotPresent"
          resources {
            limits = {
              cpu    = "100m"
              memory = "100Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
          volume_mount {
            mount_path = "/tmp/bootstrap/"
            name       = "grpc-td-conf"
          }
        }

        volume {
          name = "grpc-td-conf"
          empty_dir {
            medium = "Memory"
          }
        }

        container {
          name  = "server-http"
          image = "ghcr.io/dantulovsky/quote-server/server:${var.app_version}"
          args = [
            "--enable_metrics",
            "--version=${var.app_version}",
            "--quote_server_grpc=xds:///quote-server-gke:8000"
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
            # Points at the bootstrap file created by the initContainer
            name  = "GRPC_XDS_BOOTSTRAP"
            value = "/tmp/grpc-xds/td-grpc-bootstrap.json"
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
              cpu    = "50m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "40Mi"
            }
          }

          volume_mount {
            mount_path = "grpc-td-conf"
            name       = "/tmp/grpc-xds/"
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
