resource "helm_release" "argo-rollouts" {
  name         = "argo-rollouts"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-rollouts"
  wait         = true
  force_update = false
  version = "1.0.1"

  values = [templatefile("${path.module}/yaml/values.yaml", {
  })]
}

resource "kubectl_manifest" "argo-dashboard" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard.yaml", {
    namespace = var.namespace
  })
}
