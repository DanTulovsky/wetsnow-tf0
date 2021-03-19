
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate

locals {
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
    "www.dusselskolk.com.",
  ]
}

resource "google_compute_managed_ssl_certificate" "wetsnow-com" {
  name = "wetsnow-cert"
  managed {
    domains = local.domains
  }
}

resource "google_compute_managed_ssl_certificate" "wetsnow-com-next" {
  name = "wetsnow-cert-20210319"
  managed {
    domains = concat(local.domains, [
      "scope.wetsnow.com",
      "weave-scope.wetsnow.com",
    ])
  }
}
