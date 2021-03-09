# data "kubectl_path_documents" "manifests" {
#   pattern = "${path.module}/yaml/k8s/*.yaml"
# }

# resource "kubectl_manifest" "web-yaml" {
#   count     = length(ata.kubectl_path_documents.manifests.documents)
#   yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
# }

resource "kubectl_manifest" "service_static_web_frontend" {
  yaml_body = templatefile("${path.module}/yaml/k8s/20-service.yaml", {
    namespace = var.namespace
  })
}
resource "kubectl_manifest" "deployment_frontend" {
  yaml_body = templatefile("${path.module}/yaml/k8s/30-deployment.yaml", {
    namespace = var.namespace
  })
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}
