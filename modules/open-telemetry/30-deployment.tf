resource "kubernetes_deployment" "otel_collector" {
  metadata {
    name      = "otel-collector"
    namespace = var.namespace

    labels = {
      app = "opentelemetry"

      component = "otel-collector"
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
            name = "otel-collector-conf"

            items {
              key  = "otel-collector-config"
              path = "otel-collector-config.yaml"
            }
          }
        }

        volume {
          name = "otel-jaeger-sampling-config"

          config_map {
            name = "jaeger-sampling-configuration"

            items {
              key  = "sampling"
              path = "jaeger-sampling-config.json"
            }
          }
        }

        container {
          name    = "otel-collector"
          image   = "otel/opentelemetry-collector-contrib:0.22.0"
          command = ["/otelcontribcol", "--config=/conf/otel-collector-config.yaml"]

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
            name           = "zpikin"
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

          volume_mount {
            name       = "otel-jaeger-sampling-config"
            mount_path = "/etc/jaeger"
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

