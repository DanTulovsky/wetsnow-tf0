resource "helm_release" "pgadmin4" {
  name         = "pgadmin4"
  namespace    = var.namespace
  repository   = "https://helm.runix.net"
  chart        = "pgadmin4"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/pgadmin4-values.yaml", {
    pgadminPassword = var.admin_password
  })]
}
