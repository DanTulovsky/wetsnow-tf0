data "kubectl_file_documents" "argo-events-docs-install" {
  content = file("install-validating-webhook.yaml")
}

resource "kubectl_manifest" "argo-events" {
  for_each  = data.kubectl_file_documents.argo-events-docs-install.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "argo-events-docs-eventbus" {
  content = file("eventbus.yaml")
}

resource "kubectl_manifest" "argo-events" {
  for_each  = data.kubectl_file_documents.argo-events-docs-eventbus.manifests
  yaml_body = each.value
}
