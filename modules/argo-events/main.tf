data "kubectl_file_documents" "argo-events-docs-install" {
  content = file("${path.module}/yaml/install.yaml")
}

resource "kubectl_manifest" "argo-events-install" {
  for_each  = data.kubectl_file_documents.argo-events-docs-install.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "argo-events-docs-install-webhook" {
  content = file("${path.module}/yaml/install.yaml")
}

resource "kubectl_manifest" "argo-events-install-webhook" {
  for_each  = data.kubectl_file_documents.argo-events-docs-install-webhook.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "argo-events-docs-eventbus" {
  content = file("${path.module}/yaml/eventbus.yaml")
}

resource "kubectl_manifest" "argo-events-eventbus" {
  for_each  = data.kubectl_file_documents.argo-events-docs-eventbus.manifests
  yaml_body = each.value
}
