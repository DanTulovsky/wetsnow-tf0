
resource "helm_release" "grafana" {
  depends_on = [
    kubernetes_secret.grafana-env-secret,
    kubernetes_secret.grafana-admin,
    kubernetes_secret.grafana-smtp,
  ]
  name         = "grafana0"
  namespace    = "monitoring"
  repository   = "https://grafana.github.io/helm-charts"
  chart        = "grafana"
  wait         = true
  force_update = false

  values = [file("${path.module}/yaml/values.yaml")]
}

resource "kubernetes_secret" "grafana-env-secret" {
  metadata {
    name      = "grafana-env-secret"
    namespace = "monitoring"
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
    namespace = "monitoring"
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
    namespace = "monitoring"
  }

  data = {
    password : var.smtp_password
    user : "apikey"
  }
  type = "Opaque"
}
