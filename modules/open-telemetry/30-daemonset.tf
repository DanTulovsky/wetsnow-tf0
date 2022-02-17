// Secret created manually and stored in password manager
resource "kubernetes_daemon_set_v1" "otel_collector-daemonset" {
  metadata {
    name      = "otel-collector-agent"
    namespace = var.namespace

    labels = {
      app       = "opentelemetry"
      component = "otel-collector-agent"
    }

    annotations = {
      "checksum/config" = kubernetes_config_map.otel-collector-agent-conf.metadata.0.resource_version
    }
  }
  spec {
    selector {
      match_labels = {
        app       = "opentelemetry"
        component = "otel-collector-agent"
      }
    }

    template {
      metadata {
        labels = {
          app       = "opentelemetry"
          component = "otel-collector-agent"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "8888"
          "prometheus.io/path"   = "/metrics"
        }
      }

      spec {
        volume {
          name = "otel-collector-config-vol"

          config_map {
            name = kubernetes_config_map.otel-collector-agent-conf.metadata[0].name

            items {
              key  = "otel-collector-config"
              path = "otel-collector-config.yaml"
            }
          }
        }

        container {
          name    = "otel-collector"
          image   = "otel/opentelemetry-collector-contrib:${var.image_version}"
          command = ["/otelcol-contrib", "--config=/conf/otel-collector-config.yaml"]

          env {
            name = "K8S_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "LIGHTSTEP_ACCESS_TOKEN"
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
          port {
            name           = "pprof"
            container_port = 1777
          }

          port {
            name           = "otlp-http"
            container_port = 55681
          }

          port {
            name           = "otlp-grpc"
            container_port = 4317
          }

          port {
            name           = "metrics"
            container_port = 8888
          }

          port {
            name           = "statsd"
            container_port = 8125
            protocol       = "UDP"
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "otel-collector-config-vol"
            mount_path = "/conf"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "13133"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "13133"
            }
          }
        }

        service_account_name            = "otelcontribcol"
        automount_service_account_token = true
      }
    }
  }
}

