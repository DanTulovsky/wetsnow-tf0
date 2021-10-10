data "kubectl_file_documents" "server_manifests" {
  content = file("${path.module}/yaml/k8s/server.yaml")
}

data "kubectl_file_documents" "agent_manifests" {
  content = file("${path.module}/yaml/k8s/agent.yaml")
}

resource "kubectl_manifest" "server" {
  count              = length(data.kubectl_file_documents.server_manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.server_manifests.documents, count.index)
  override_namespace = var.namespace
  wait               = true
}

resource "kubectl_manifest" "agent" {
  count              = length(data.kubectl_file_documents.agent_manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.agent_manifests.documents, count.index)
  override_namespace = var.namespace
  wait               = true
}
