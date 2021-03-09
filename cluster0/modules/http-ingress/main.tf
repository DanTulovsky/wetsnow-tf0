resource "google_compute_global_address" "default" {
  name    = "global-ip0"
  address = "34.120.237.55"
}

resource "kubernetes_ingress" "ambassador" {
  wait_for_load_balancer = true
  metadata {
    name      = "wetsnow-ingress"
    namespace = "ambassador"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" : google_compute_global_address.default.name
      # https://github.com/hashicorp/terraform-provider-kubernetes/issues/446
      #   "networking.gke.io/managed-certificates" : google_compute_managed_ssl_certificate.wetsnow-com.name
      "ingress.gcp.kubernetes.io/pre-shared-cert" : google_compute_managed_ssl_certificate.wetsnow-com.name
      "kubernetes.io/ingress.class" : "gce"
    }
  }
  spec {
    backend {
      service_name = "ambassador"
      service_port = 8080
    }
  }
}
