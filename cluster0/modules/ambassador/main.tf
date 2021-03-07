
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "helm_release" "ambassador" {
  name         = "ambassador"
  namespace    = "ambassador"
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    licenseKey = chomp(file("${path.module}/.secret/licenseKey.txt"))
  })]
}

data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/yaml/k8s/*.yaml"
}

resource "kubectl_manifest" "ambassador-yaml" {
  depends_on = [helm_release.ambassador]
  count      = length(data.kubectl_path_documents.manifests.documents)
  yaml_body  = element(data.kubectl_path_documents.manifests.documents, count.index)
}


resource "kubernetes_secret" "ambassador-keycloak-secret" {
  metadata {
    name      = "ambassador-keycloak-secret"
    namespace = "ambassador"
  }

  data = {
    "oauth2-client-secret" = chomp(file("${path.module}/.secret/ambassador-keycloak-secret.txt"))
  }

  type = "Opaque"
}

resource "kubernetes_secret" "pepper-poker-keycloak-secret" {
  metadata {
    name      = "pepper-poker-keycloak-secret"
    namespace = "ambassador"
  }

  data = {
    "oauth2-client-secret" = chomp(file("${path.module}/.secret/pepper-poker-keycloak-secret.txt"))
  }

  type = "Opaque"
}

resource "kubernetes_secret" "default-keycloak-secret" {
  metadata {
    name      = "default-keycloak-secret"
    namespace = "ambassador"
  }

  data = {
    "oauth2-client-secret" = chomp(file("${path.module}/.secret/default-keycloak-secret.txt"))
  }

  type = "Opaque"
}
