
resource "helm_release" "keycloak" {
  #   depends_on   = [kubernetes_secret.keycloak-db-secret]
  name         = "keycloak"
  namespace    = var.namespace
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "keycloak"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    adminPassword      = var.admin_password
    managementPassword = var.management_password
    dbPassword         = var.db_password
    promEnabled        = var.prom_enabled
  })]
}
