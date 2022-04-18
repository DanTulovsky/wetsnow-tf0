resource "kubectl_manifest" "argo-events-sensor-log" {
  yaml_body = templatefile("${path.module}/yaml/k8s/sensors/logger.yaml", {
    namespace = var.namespace
  })
}
