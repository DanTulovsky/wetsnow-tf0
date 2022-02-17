# Main argo-events
data "kubectl_file_documents" "argo-events-docs-install" {
  content = file("${path.module}/yaml/install.yaml")
}

resource "kubectl_manifest" "argo-events-install" {
  for_each  = data.kubectl_file_documents.argo-events-docs-install.manifests
  yaml_body = each.value
}

# Validating Webhook
data "kubectl_file_documents" "argo-events-docs-install-webhook" {
  content = file("${path.module}/yaml/install.yaml")
}

resource "kubectl_manifest" "argo-events-install-webhook" {
  for_each  = data.kubectl_file_documents.argo-events-docs-install-webhook.manifests
  yaml_body = each.value
}

# Per-namespace event bus
resource "kubectl_manifest" "argo-events-eventbus" {
  for_each = var.all_namespaces
  yaml_body = templatefile("${path.module}/yaml/eventbus.yaml", {
    namespace = each.value
  })
}
