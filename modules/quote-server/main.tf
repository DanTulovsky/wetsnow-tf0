resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  count = var.prom_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}

resource "kubectl_manifest" "ambassador-tracing" {
  depends_on = [kubernetes_deployment.quote_server_http]
  yaml_body  = file("${path.module}/yaml/k8s/rollout.yaml")
}
