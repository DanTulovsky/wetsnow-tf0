resource "helm_release" "ambassador" {
  name         = "ambassador"
  namespace    = var.namespace
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    licenseKey = var.license_key
  })]
}

data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/yaml/k8s/*.yaml"
  vars = {
    namespace = var.namespace
  }
}

resource "kubectl_manifest" "ambassador-yaml" {
  depends_on = [helm_release.ambassador]
  # count      = length(data.kubectl_path_documents.manifests.documents)
  count     = 25
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}


resource "kubernetes_secret" "ambassador-keycloak-secret" {
  metadata {
    name      = "ambassador-keycloak-secret"
    namespace = var.namespace
  }

  data = {
    "oauth2-client-secret" = var.ambassador_keycloak_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "pepper-poker-keycloak-secret" {
  metadata {
    name      = "pepper-poker-keycloak-secret"
    namespace = var.namespace
  }

  data = {
    "oauth2-client-secret" = var.pepper_poker_keycloak_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "default-keycloak-secret" {
  metadata {
    name      = "default-keycloak-secret"
    namespace = var.namespace
  }

  data = {
    "oauth2-client-secret" = var.default_keycloak_secret
  }

  type = "Opaque"
}
