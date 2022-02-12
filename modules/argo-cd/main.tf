resource "helm_release" "argo-cd" {
  name         = "argo-cd"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-cd"
  chart        = "argo-cd"
  wait         = true
  force_update = true
  version      = "3.33.5"

  values = [templatefile("${path.module}/yaml/values.yaml", {
    argo_version = var.argo_version
  })]
}
