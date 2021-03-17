
resource "helm_release" "grafana" {
  depends_on = [
    kubernetes_secret.grafana-env-secret,
    kubernetes_secret.grafana-admin,
    kubernetes_secret.grafana-smtp,
  ]
  name         = "grafana0"
  namespace    = var.namespace
  repository   = "https://grafana.github.io/helm-charts"
  chart        = "grafana"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    promEnabled = var.prom_enabled
  })]
}

resource "kubernetes_secret" "grafana-env-secret" {
  metadata {
    name      = "grafana-env-secret"
    namespace = var.namespace
  }

  data = {
    GF_AUTH_GENERIC_OAUTH_CLIENT_ID : "grafana.wetsnow.com"
    GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET : var.oauth_secret
    GF_DATABASE_PASSWORD : var.db_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "grafana-admin" {
  metadata {
    name      = "grafana-admin"
    namespace = var.namespace
  }

  data = {
    admin-password : var.admin_password
    admin-user : "admin"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "grafana-smtp" {
  metadata {
    name      = "grafana-smtp"
    namespace = var.namespace
  }

  data = {
    password : var.smtp_password
    user : "apikey"
  }
  type = "Opaque"
}
