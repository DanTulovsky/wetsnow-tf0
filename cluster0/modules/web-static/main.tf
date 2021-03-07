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

# data "kubectl_path_documents" "manifests" {
#   pattern = "${path.module}/yaml/k8s/*.yaml"
# }

# resource "kubectl_manifest" "web-yaml" {
#   count     = length(data.kubectl_path_documents.manifests.documents)
#   yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
# }

resource "kubectl_manifest" "service_static_web_frontend" {
  yaml_body = file("${path.module}/yaml/k8s/20-service.yaml")
}
resource "kubectl_manifest" "deployment_frontend" {
  yaml_body = file("${path.module}/yaml/k8s/30-deployment.yaml")
}

resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  yaml_body = file("${path.module}/yaml/k8s/00-monitoring-prom.yaml")
}
