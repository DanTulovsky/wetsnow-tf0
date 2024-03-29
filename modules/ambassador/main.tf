resource "helm_release" "ambassador" {
  depends_on   = [kubectl_manifest.ambassador-backend-config, kubectl_manifest.ambassador-backend-config-iap]
  name         = var.name
  namespace    = var.namespace
  repository   = "https://app.getambassador.io"
  chart        = "edge-stack"
  wait         = true
  force_update = false
  version      = var.chart_version

  values = [
    templatefile("${path.module}/yaml/values.yaml", {
      licenseKey    = var.license_key
      backendConfig = var.backend_config
      name          = var.name
      app_version   = var.app_version
    })
  ]
}

# BEGIN: All of these files must have exactly 1 manifest in them
resource "kubectl_manifest" "ambassador-global" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/00-ambassador-global.yaml")
}
resource "kubectl_manifest" "ambassador-endpoint" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/00-ambassador-endpoint.yaml")
}
resource "kubectl_manifest" "ambassador-hosts" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/05-ambassador-hosts.yaml")
}
resource "kubectl_manifest" "ambassador-listener-http" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/07-ambassador-http-listener.yaml")
}
resource "kubectl_manifest" "ambassador-listener-https" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/07-ambassador-https-listener.yaml")
}
resource "kubectl_manifest" "ambassador-tracing" {
  depends_on = [helm_release.ambassador]
  yaml_body  = file("${path.module}/yaml/k8s/30-ambassador-tracing.yaml")
}
resource "kubectl_manifest" "ambassador-backend-config" {
  yaml_body = file("${path.module}/yaml/k8s-gcp/backend-config.yaml")
}
# END: All of these files must have exactly 1 manifest in them

# Maps
data "kubectl_file_documents" "ambassador-maps" {
  content = file("${path.module}/yaml/k8s/10-ambassador-maps.yaml")
}

resource "kubectl_manifest" "test" {
  count     = length(data.kubectl_file_documents.ambassador-maps.documents)
  yaml_body = element(data.kubectl_file_documents.ambassador-maps.documents, count.index)
}

// IAP
resource "kubectl_manifest" "ambassador-backend-config-iap" {
  yaml_body = file("${path.module}/yaml/k8s-gcp/backend-config-iap.yaml")
}

resource "kubernetes_service" "ambassador-iap" {
  depends_on = [helm_release.ambassador]
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
  metadata {
    name      = "ambassador-iap"
    namespace = var.namespace
    annotations = {
      "cloud.google.com/neg" : "{\"ingress\": true}"
      "cloud.google.com/backend-config" : "{\"default\": \"${kubectl_manifest.ambassador-backend-config-iap.name}\"}"
      "cloud.google.com/app-protocols" : "{\"grpc\": \"HTTP2\"}"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "ambassador"
      "app.kubernetes.io/name"     = "ambassador"
    }
    port {
      port        = 8080
      target_port = 8080
      name        = "http"
    }
    port {
      port        = 8443
      target_port = 8443
      name        = "grpc"
    }

    type = "NodePort"
  }
}