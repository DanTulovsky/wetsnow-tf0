resource "helm_release" "kube-state-metrics" {
  name         = "kube-state-metrics"
  namespace    = var.namespace
  repository   = "https://prometheus-community.github.io/helm-charts"
  chart        = "kube-state-metrics"
  wait         = true
  force_update = false

  values = [
    templatefile("${path.module}/yaml/values.yaml", {
    })
  ]
}
