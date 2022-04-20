resource "google_compute_global_address" "default" {
  name    = "global-ip0"
  address = "34.120.237.55"
}

resource "kubernetes_ingress_v1" "ambassador" {
  wait_for_load_balancer = true
  metadata {
    name      = "wetsnow-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" : google_compute_global_address.default.name
      # https://github.com/hashicorp/terraform-provider-kubernetes/issues/446
      #   "networking.gke.io/managed-certificates" : google_compute_managed_ssl_certificate.wetsnow-com.name
      "ingress.gcp.kubernetes.io/pre-shared-cert" : google_compute_managed_ssl_certificate.wetsnow-com-20220419-00.name
      "kubernetes.io/ingress.class" : "gce"
      "kubernetes.io/ingress.global-static-ip-name" : "global-ip0"
    }
  }
  spec {
    # send everything to ambassador, because we cannot send a across namespaces
    default_backend {
      # default to IAP
      service {
        name = "ambassador-iap"
        port {
          number = 8080
        }
      }
    }
    rule {
      host = "www.wetsnow.com"
      http {
        path {
          backend {
            service {
              name = "ambassador-iap"
              port {
                number = 8080
              }
            }
          }
          path = "/auth/*"
        }
        path {
          backend {
            service {
              name = "ambassador"
              port {
                number = 8080
              }
            }
          }
          path = "/*"
        }
      }
    }
    rule {
      host = "www.dusselskolk.com"
      http {
        path {
          backend {
            service {
              name = "ambassador"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
