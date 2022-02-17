resource "kubectl_manifest" "argo-events-source-calendar" {
  yaml_body = templatefile("${path.module}/yaml/sources/calendar.yaml", {
    namespace = var.namespace
  })
}
