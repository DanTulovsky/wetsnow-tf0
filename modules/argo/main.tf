resource "helm_release" "argo-rollouts" {
  name         = "argo-rollouts"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-rollouts"
  wait         = true
  force_update = true
  #  version      = "2.9.3"

  values = [templatefile("${path.module}/yaml/values.yaml", {
    argo_version = var.argo_version
  })]
}

