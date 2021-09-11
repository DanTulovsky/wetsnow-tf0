resource "kubernetes_network_policy" "quote_server" {
  metadata {
    name      = "quote-server-network-policy"
    namespace = "web"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "app"
        operator = "In"
        values = [
          "quote"
        ]
      }
      match_expressions {
        key      = "component"
        operator = "In"
        values = [
          "server-http"
        ]
      }
    }

    ingress {
      ports {
        port     = var.port_http
        protocol = "TCP"
      }
      ports {
        port     = var.port_grpc
        protocol = "TCP"
      }

      from {
        pod_selector {
          match_labels = {
            app       = "static-web"
            component = "frontend"
          }
        }
      }
    }

    egress {}
    # single empty rule to allow all egress traffic

    policy_types = [
      "Ingress",
    "Egress"]
  }
}
