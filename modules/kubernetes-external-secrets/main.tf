resource "helm_release" "kubernetes-external-secrets" {
  name         = "kubernetes-external-secrets"
  namespace    = var.namespace
  repository   = "https://external-secrets.github.io/kubernetes-external-secrets"
  chart        = "kubernetes-external-secrets"
  wait         = true
  force_update = false

  values = [
    templatefile("${path.module}/yaml/values.yaml", {
      appVersion     = var.app_version
      projectID      = var.project_id
      serviceAccount = var.service_account
    })
  ]
}
