resource "kubectl_manifest" "argo-events-sensor-log" {
  yaml_body = templatefile("${path.module}/yaml/sensors/logger.yaml", {
    namespace = var.namespace
  })
}
