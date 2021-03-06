# https://dev.to/souzaxx/terraform-helm-57bk

resource "helm_release" "prometheus" {
  depends_on = [kubernetes_secret.lightstep-config]
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kube-prometheus"
  #   version    = "4.1.2"
  wait         = true
  force_update = true

  values = [templatefile("${path.module}/yaml/values.yaml", {})]
}

resource "helm_release" "prometheus-pushgateway" {
  name       = "prometheus-pushgateway"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-pushgateway"
  #   version    = "4.1.2"
  wait = true

  values = [templatefile("${path.module}/yaml/pushgateway-values.yaml", {})]
}

resource "kubernetes_secret" "lightstep-config" {
  metadata {
    name      = "lightstep-config"
    namespace = "monitoring"
  }

  data = {
    "config.yaml" = file("${path.module}/.secret/lightstep-config.yaml")
  }

  type = "Opaque"
}
