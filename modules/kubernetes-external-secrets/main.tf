resource "helm_release" "kubernetes-external-secrets" {
  #   depends_on   = [kubernetes_secret.keycloak-db-secret]
  name         = "kubernetes-external-secrets"
  namespace    = var.namespace
  repository   = "https://external-secrets.github.io/kubernetes-external-secrets"
  chart        = "kubernetes-external-secrets"
  wait         = true
  force_update = false

  values = [
    templatefile("${path.module}/yaml/values.yaml", {
      appVersion = var.app_version
    })
  ]
}
