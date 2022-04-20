
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate

# to add a cert, update the date in the name, add a new cert and
# update kubernetes_ingress.ambassador in main.tf
# then remove the previous instance
# this causes downtime!!

# new
resource "google_compute_managed_ssl_certificate" "wetsnow-com-20220419" {
  name = "wetsnow-com-20220419"
  managed {
    domains = sort([
      "ambassador-admin.wetsnow.com.",
      "argocd.wetsnow.com.",
      "dusselskolk.com.",
      "grafana.wetsnow.com.",
      "kubecost.wetsnow.com.",
      "login.wetsnow.com.",
      "pepper-poker.wetsnow.com"
      "pgadmin.wetsnow.com.",
      "prometheus.wetsnow.com.",
      "rollouts.wetsnow.com",
      "scope.wetsnow.com",
      "weave-scope.wetsnow.com",
      "wetsnow.com.",
      "www.dusselskolk.com.",
      "www.wetsnow.com.",
    ])
  }
}

resource "google_compute_managed_ssl_certificate" "wetsnow-com-20220419-00" {
  name = "wetsnow-com-20220419"
  managed {
    domains = sort([
      "ambassador-admin.wetsnow.com.",
      "argocd.wetsnow.com.",
      "dusselskolk.com.",
      "grafana.wetsnow.com.",
      "kubecost.wetsnow.com.",
      "login.wetsnow.com.",
      "prometheus.wetsnow.com.",
      "rollouts.wetsnow.com",
      "wetsnow.com.",
      "www.dusselskolk.com.",
      "www.wetsnow.com.",
    ])
  }
}
