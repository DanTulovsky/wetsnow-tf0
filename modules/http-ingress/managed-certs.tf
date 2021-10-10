
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate

locals {
  domains = [
    "ambassador-admin.wetsnow.com.",
    "dusselskolk.com.",
    "grafana.wetsnow.com.",
    "login.wetsnow.com.",
    "pepper-poker.wetsnow.com.",
    "pgadmin.wetsnow.com.",
    "prometheus.wetsnow.com.",
    "rollouts.wetsnow.com",
    "scope.wetsnow.com",
    "weave-scope.wetsnow.com",
    "wetsnow.com.",
    "www.dusselskolk.com.",
    "www.wetsnow.com.",
  ]
}

# old
resource "google_compute_managed_ssl_certificate" "wetsnow-com-20211010" {
  name = "wetsnow-cert-20211010"
  managed {
    domains = concat(local.domains, [
      "wetsnow.com",
      "www.wetsnow.com",
      "ambassador-admin.wetsnow.com",
      "pepper-poker.wetsnow.com",
      "grafana.wetsnow.com",
      "login.wetsnow.com",
      "prometheus.wetsnow.com",
      "pgadmin.wetsnow.com",
      "kafka-ui.wetsnow.com",
      "dusselskolk.com",
      "www.dusselskolk.com",
      "parca.wetsnow.com",
    ])
  }
}

# to add a cert, update the date in the name, add a new cert and
# update kubernetes_ingress.ambassador in main.tf
# then remove the previous instance
# this causes downtime!!
resource "google_compute_managed_ssl_certificate" "wetsnow-com-20211010-01" {
  name = "wetsnow-cert-20211010-01"
  managed {
    domains = concat(local.domains, [
      "parca.wetsnow.com",
    ])
  }
}
