terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "service_static_web_frontend" {
  yaml_body = file("${path.module}/yaml/20-service.yaml")
}
resource "kubectl_manifest" "deployment_frontend" {
  yaml_body = file("${path.module}/yaml/30-deployment.yaml")
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = file("${path.module}/yaml/00-monitoring-prom.yaml")
}
