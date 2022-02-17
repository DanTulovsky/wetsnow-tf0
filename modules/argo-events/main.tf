resource "helm_release" "argo-events" {
  name         = "argo-events"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-events"
  wait         = true
  force_update = true
  #  version      = "2.9.3"

  values = [templatefile("${path.module}/yaml/values.yaml", {
    argo_version   = var.argo_version
    all_namespaces = var.all_namespaces
  })]
}

# Per-namespace event bus
resource "kubectl_manifest" "argo-events-eventbus" {
  for_each = var.all_namespaces
  yaml_body = templatefile("${path.module}/yaml/k8s/eventbus.yaml", {
    namespace = each.value
  })
}
