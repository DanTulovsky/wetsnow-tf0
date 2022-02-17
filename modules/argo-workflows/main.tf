resource "helm_release" "argo-workflows" {
  name         = "argo-events"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-workflows"
  wait         = true
  force_update = true
  #  version      = "2.9.3"

  values = [templatefile("${path.module}/yaml/values.yaml", {
    argo_version = var.argo_version
  })]
}
