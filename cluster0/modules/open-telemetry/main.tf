
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubernetes_config_map" "otel-collector-conf" {
  metadata {
    name      = "otel-collector-conf"
    namespace = "observability"
  }

  data = {
    "otel-collector-config" = templatefile("${path.module}/yaml/config.yaml", {
      lightstepAccessToken = chomp(file("${path.module}/.secret/lightstep-access-token.txt"))
    })
  }
}

resource "kubectl_manifest" "account-otel" {
  yaml_body = file("${path.module}/yaml/00-account.yaml")
}
resource "kubectl_manifest" "service-otel" {
  yaml_body = file("${path.module}/yaml/20-service.yaml")
}
resource "kubectl_manifest" "deployment-otel" {
  depends_on = [kubernetes_config_map.otel-collector-conf]
  yaml_body  = file("${path.module}/yaml/30-deployment.yaml")
}
resource "kubectl_manifest" "sampling-config" {
  yaml_body = file("${path.module}/yaml/40-sampling-config.yaml")
}

