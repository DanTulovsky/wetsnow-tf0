// Secret created manually and stored in password manager
resource "kubernetes_deployment_v1" "otel_collector" {
  metadata {
    name      = "otel-collector"
    namespace = var.namespace

    labels = {
      app       = "opentelemetry"
      component = "otel-collector"
    }

    annotations = {
      "checksum/config" = base64sha256(kubernetes_config_map.otel-collector-conf.data.otel-collector-config)
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app       = "opentelemetry"
        component = "otel-collector"
      }
    }

    template {
      metadata {
        labels = {
          app       = "opentelemetry"
          component = "otel-collector"
        }
      }

      spec {
        volume {
          name = "otel-collector-config-vol"

          config_map {
            name = kubernetes_config_map.otel-collector-conf.metadata[0].name

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
            name           = "opencensus"
            container_port = 55678
          }

          port {
            name           = "zpages"
            container_port = 55679
          }

          port {
            name           = "pprof"
            container_port = 1777
          }

          port {
            name           = "otlp-leg-grpc"
            container_port = 55680
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
            name           = "jaeger-http-1"
            container_port = 14250
          }

          port {
            name           = "jaeger-http-2"
            container_port = 14268
          }

          port {
            name           = "zipkin"
            container_port = 9411
          }

          port {
            name           = "metrics"
            container_port = 8888
          }

          port {
            name           = "thrift-binary"
            container_port = 6832
            protocol       = "UDP"
          }

          port {
            name           = "thrift-compact"
            container_port = 6831
            protocol       = "UDP"
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

    min_ready_seconds         = 5
    progress_deadline_seconds = 120
  }
}

