resource "kubernetes_config_map" "otel-collector-conf" {
  metadata {
    name      = "otel-collector-conf"
    namespace = var.namespace
  }

  data = {
    "otel-collector-config" = templatefile("${path.module}/yaml/config.yaml", {
      metricsReceivers  = var.otel.metrics_receivers
      metricsProcessors = var.otel.metrics_processors
      metricsExporters  = var.otel.metrics_exporters
      traceReceivers    = var.otel.trace_receivers
      traceProcessors   = var.otel.trace_processors
      traceExporters    = var.otel.trace_exporters
    })
  }
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  count = var.prom_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/yaml/k8s/00-monitoring-prom.yaml", {
    namespace = var.namespace
  })
}

resource "helm_release" "ddog-agent" {
  name       = "ddog-agent"
  namespace  = var.namespace
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  #   version    = "4.1.2"
  wait         = true
  force_update = false

  values = [
    templatefile("${path.module}/yaml/ddog-values.yaml", {
      gke         = var.gke
      clusterName = var.cluster_name
    })
  ]
}
