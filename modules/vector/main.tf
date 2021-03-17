resource "helm_release" "vector" {
  name      = "vector"
  namespace = var.namespace
  # repository   = "https://packages.timber.io/helm/latest"
  repository = "https://packages.timber.io/helm/nightly"
  chart      = "vector-agent"
  # for metrics export
  version      = "0.12.0-nightly-2021-03-07"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {})]
}

# data "kubectl_path_documents" "manifests" {
#   pattern = "${path.module}/yaml/k8s/*.yaml"
# }

resource "kubectl_manifest" "vector-yaml" {
  depends_on = [helm_release.vector]
  count      = var.prom_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}
