
resource "helm_release" "keycloak" {
  #   depends_on   = [kubernetes_secret.keycloak-db-secret]
  name         = "keycloak"
  namespace    = "auth"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "keycloak"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    adminPassword      = chomp(file("${path.module}/.secret/keycloak-admin-password.txt"))
    managementPassword = chomp(file("${path.module}/.secret/keycloak-management-password.txt"))
    dbPassword         = chomp(file("${path.module}/.secret/keycloak-db-password.txt"))
  })]
}

# resource "kubernetes_secret" "keycloak-db-secret" {
#   metadata {
#     name      = "keycloak-db-secret"
#     namespace = "auth"
#   }

#   data = {
#     KEYCLOAK_DATABASE_NAME : "bitnami_keycloak"
#     KEYCLOAK_DATABASE_HOST : "db1.gke-internal.wetsnow.com"
#     KEYCLOAK_DATABASE_PORT : "5432"
#     KEYCLOAK_DATABASE_USER : "bn_keycloak"
#     KEYCLOAK_DATABASE_PASSWORD : chomp(file("${path.module}/.secret/keycloak-db-password.txt"))
#   }

#   type = "Opaque"
# }
