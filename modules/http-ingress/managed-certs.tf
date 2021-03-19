
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate
resource "google_compute_managed_ssl_certificate" "wetsnow-com" {
  name = "wetsnow-cert"

  managed {
    domains = [
      "wetsnow.com.",
      "www.wetsnow.com.",
      "ambassador-admin.wetsnow.com.",
      "pepper-poker.wetsnow.com.",
      "grafana.wetsnow.com.",
      "login.wetsnow.com.",
      "prometheus.wetsnow.com.",
      "pgadmin.wetsnow.com.",
      "kafka-ui.wetsnow.com.",
      "dusselskolk.com.",
      "scope.wetsnow.com",
      "weave-scope.wetsnow.com",
      "www.dusselskolk.com.",
    ]
  }
}
