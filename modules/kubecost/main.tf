
resource "helm_release" "kubecost" {
  name         = "kubecost"
  namespace    = var.namespace
  repository   = "https://kubecost.github.io/cost-analyzer/"
  chart        = "cost-analyzer"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    namespace = var.namespace
  })]
}