resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}
