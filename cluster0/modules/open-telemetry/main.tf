resource "kubernetes_config_map" "otel-collector-conf" {
  metadata {
    name      = "otel-collector-conf"
    namespace = var.namespace
  }

  data = {
    "otel-collector-config" = templatefile("${path.module}/yaml/config.yaml", {
      lightstepAccessToken = var.lightstep_access_token
    })
  }
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
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
  })]
}
