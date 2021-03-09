
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

data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/yaml/k8s/*.yaml"
  vars = {
    namespace = var.namespace
  }
}

resource "kubectl_manifest" "otel-yaml" {
  depends_on = [kubernetes_config_map.otel-collector-conf]
  # count      = length(data.kubectl_path_documents.manifests.documents)
  count     = 7
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}

# resource "kubectl_manifest" "otel-yaml" {
#   depends_on = [kubernetes_config_map.otel-collector-conf]

#   for_each = toset(data.kubectl_path_documents.manifests.documents)

#   yaml_body = each.key
# }
