resource "helm_release" "prometheus" {
  depends_on = [kubernetes_secret.lightstep-config]
  count      = var.enabled ? 1 : 0
  name       = "prom0"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kube-prometheus"
  #   version    = "4.1.2"
  wait         = true
  force_update = false

  values = [
    templatefile("${path.module}/yaml/values.yaml", {
      operator_version     = var.operator_version
      otel_sidecar_version = var.otel_sidecar_version
    })
  ]
}

resource "kubernetes_config_map" "lightstep-config" {
  metadata {
    name      = "lightstep-config"
    namespace = var.namespace
  }

  data = {
    "config.yaml" = templatefile("${path.module}/yaml/lightstep-config.yaml", {
      clusterName = var.cluster_name
    })
  }
}
