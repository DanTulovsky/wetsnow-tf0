
resource "kubernetes_config_map" "otel-collector-conf" {
  metadata {
    name      = "otel-collector-conf"
    namespace = var.namespace
  }

  data = {
    "otel-collector-config" = templatefile("${path.module}/yaml/config.yaml", {
      lightstepAccessToken = var.lightstep_access_token
    })
  }
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}

# data "kubectl_path_documents" "manifests" {
#   pattern = "${path.module}/yaml/k8s/*.yaml"
#   vars = {
#     namespace = var.namespace
#   }
# }

# resource "kubectl_manifest" "otel-yaml" {
#   depends_on = [kubernetes_config_map.otel-collector-conf]
#   # count      = length(data.kubectl_path_documents.manifests.documents)
#   count     = 7
#   yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
# }
