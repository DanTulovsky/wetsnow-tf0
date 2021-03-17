resource "helm_release" "ambassador" {
  name         = "ambassador"
  namespace    = var.namespace
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    licenseKey  = var.license_key
    promEnabled = var.prom_enabled
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
  count     = 24
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}

resource "kubectl_manifest" "ambassador-backend-config" {
  depends_on = [helm_release.ambassador]
  count      = var.gke ? 1 : 0
  yaml_body  = file("${path.module}/yaml/k8s-gcp/backend-config.yaml")
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


resource "kubernetes_secret" "lightstep-access-token" {
  metadata {
    name      = "lightstep-access-token"
    namespace = var.namespace
  }

  data = {
    "token.txt" = var.lightstep_access_token
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
