# https://dev.to/souzaxx/terraform-helm-57bk

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

  values = [templatefile("${path.module}/yaml/values.yaml", {
    operator_version     = var.operator_version
    otel_sidecar_version = var.otel_sidecar_version
  })]
}

# resource "helm_release" "prometheus-pushgateway" {
#   depends_on = [helm_release.prometheus]
#   name       = "prometheus-pushgateway"
#   namespace  = var.namespace
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus-pushgateway"
#   #   version    = "4.1.2"
#   wait = true

#   values = [templatefile("${path.module}/yaml/pushgateway-values.yaml", {})]
# }

resource "kubernetes_secret" "lightstep-config" {
  metadata {
    name      = "lightstep-config"
    namespace = var.namespace
  }

  data = {
    "config.yaml" = templatefile("${path.module}/yaml/lightstep-config.yaml", {
      accessToken = var.lightstep_access_token
      clusterName = var.cluster_name
    })
  }

  type = "Opaque"
}
