resource "kubernetes_config_map" "otel-collector-conf" {
  metadata {
    name      = "otel-collector-conf"
    namespace = var.namespace
  }

  data = {
    "otel-collector-config" = templatefile("${path.module}/yaml/config.yaml", {
      lightstepAccessToken = var.lightstep_access_token
      metricsReceivers     = var.kafka.metrics_receivers
      metricsProcessors    = var.kafka.metrics_processors
      metricsExporters     = var.kafka.metrics_exporters
      traceReceivers       = var.kafka.trace_receivers
      traceProcessors      = var.kafka.trace_processors
      traceExporters       = var.kafka.trace_exporters
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

  values = [templatefile("${path.module}/yaml/ddog-values.yaml", {
    lightstepAccessToken = var.lightstep_access_token
    datadogApiKey        = var.datadog_api_key
    gke                  = var.gke
    clusterName          = var.cluster_name
  })]
}
