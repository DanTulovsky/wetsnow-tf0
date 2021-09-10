resource "kubernetes_service" "quote_server_http" {
  metadata {
    name      = "quote-server-http"
    namespace = var.namespace

    labels = {
      app       = "quote"
      component = "server-http"
      service   = "quote-server-http"
      tier      = "production"
    }

    annotations = {
      "cloud.google.com/neg" : "{\"exposed_ports\":{\"${var.port_http}\":{}}}"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["cloud.google.com/neg-status"]
    ]
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = var.port_http
      target_port = "http"
    }

    selector = {
      app       = "quote"
      component = "server-http"
      tier      = "production"
    }

    cluster_ip       = "None"
    type             = "ClusterIP"
    session_affinity = "None"
  }
}
