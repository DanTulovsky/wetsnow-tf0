
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
      lightstepAccessToken = var.lightstep_access_token
    })
  }
}

data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/yaml/k8s/*.yaml"
}

resource "kubectl_manifest" "otel-yaml" {
  depends_on = [kubernetes_config_map.otel-collector-conf]
  # count      = length(data.kubectl_path_documents.manifests.documents)
  count     = 7
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}
