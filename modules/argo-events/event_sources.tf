resource "kubectl_manifest" "argo-events-source-calendar" {
  yaml_body = templatefile("${path.module}/yaml/k8s/sources/calendar.yaml", {
    namespace = var.namespace
  })
}
