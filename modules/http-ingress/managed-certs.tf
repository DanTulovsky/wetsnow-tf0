
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
# to add a cert, update the date in the name, add a new cert and
# update kubernetes_ingress.ambassador in main.tf
# then remove the previous instance
# this causes downtime!!
resource "google_compute_managed_ssl_certificate" "wetsnow-com-20200502" {
  name = "wetsnow-cert-20210502"
  managed {
    domains = concat(local.domains, [
      "scope.wetsnow.com",
      "weave-scope.wetsnow.com",
      "traefik.wetsnow.com",
    ])
  }
}