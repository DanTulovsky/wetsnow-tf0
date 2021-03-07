
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "helm_release" "vector" {
  name         = "vector"
  namespace    = "vector"
  repository   = "https://packages.timber.io/helm/latest"
  chart        = "vector-agent"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {})]
}

# data "kubectl_path_documents" "manifests" {
#   pattern = "${path.module}/yaml/k8s/*.yaml"
# }

resource "kubectl_manifest" "vector-yaml" {
  depends_on = [helm_release.vector]
  yaml_body  = file("${path.module}/yaml/k8s/00-monitoring-prom.yaml")
}
