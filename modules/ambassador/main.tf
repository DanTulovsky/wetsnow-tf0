resource "helm_release" "ambassador" {
  name         = var.name
  namespace    = var.namespace
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    licenseKey  = var.license_key
    promEnabled = var.prom_enabled
    gke         = var.gke
    backendConfig = var.backend_config
    name          = var.name
    id            = var.id
  })]
}

data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/yaml/k8s/*.yaml"
  vars = {
    namespace = var.namespace
  }
}

data "kubectl_path_documents" "manifests-iap" {
  pattern = "${path.module}/yaml/k8s-iap/*.yaml"
  vars = {
    namespace = var.namespace
  }
}

# these are open to the internet
resource "kubectl_manifest" "ambassador-yaml" {
  depends_on = [helm_release.ambassador]
  # This doesn't work on the first install
  # count      = var.id == "default" ? length(data.kubectl_path_documents.manifests.documents) : 0
  count     = var.id == "default" ? 30 : 0
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}

# these are behind IAP
resource "kubectl_manifest" "ambassador-iap-yaml" {
  depends_on = [helm_release.ambassador]
  # This doesn't work on the first install
  # count      = var.id == "iap" ? length(data.kubectl_path_documents.manifests.documents) : 0
  count     = var.id == "iap" ? 30 : 0
  yaml_body = element(data.kubectl_path_documents.manifests-iap.documents, count.index)
}

resource "kubectl_manifest" "ambassador-backend-config" {
  depends_on = [helm_release.ambassador]
  count      = var.gke ? 1 : 0
  yaml_body  = file("${path.module}/yaml/k8s-gcp/backend-config.yaml")
}

resource "kubectl_manifest" "ambassador-backend-config-iap" {
  depends_on = [helm_release.ambassador]
  count      = var.gke ? 1 : 0
  yaml_body  = file("${path.module}/yaml/k8s-gcp/backend-config-iap.yaml")
}

resource "kubernetes_secret" "ambassador-keycloak-secret" {
  count     = var.id == "iap" ? 1 : 0
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
  count     = var.id == "iap" ? 1 : 0
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
  count     = var.id == "iap" ? 1 : 0
  metadata {
    name      = "default-keycloak-secret"
    namespace = var.namespace
  }

  data = {
    "oauth2-client-secret" = var.default_keycloak_secret
  }

  type = "Opaque"
}
