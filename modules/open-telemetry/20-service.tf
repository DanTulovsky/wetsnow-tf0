resource "kubernetes_service" "otel_collector" {
  metadata {
    name      = "otel-collector"
    namespace = var.namespace

    labels = {
      app = "opentelemetry"
      component = "otel-collector"
      service = "otel-collector"
    }
  }

  spec {
    port {
      name        = "opencensus"
      protocol    = "TCP"
      port        = 55678
      target_port = "55678"
    }

    port {
      name        = "otlp-leg-grpc"
      protocol    = "TCP"
      port        = 55680
      target_port = "55680"
    }

    port {
      name        = "otlp-http"
      port        = 55681
      target_port = "55681"
    }

    port {
      name        = "otlp-grpc"
      port        = 4317
      target_port = "4317"
    }

    port {
      name = "jaeger-grpc"
      port = 14250
    }

    port {
      name = "jaeger-thrift-http"
      port = 14268
    }

    port {
      name = "zipkin"
      port = 9411
    }

    port {
      name = "metrics"
      port = 8888
    }

    port {
      name     = "thrift-binary"
      protocol = "UDP"
      port     = 6832
    }

    port {
      name     = "thrift-compact"
      protocol = "UDP"
      port     = 6831
    }

    port {
      name     = "statsd"
      protocol = "UDP"
      port     = 8125
    }

    selector = {
      component = "otel-collector"
    }
  }
}

