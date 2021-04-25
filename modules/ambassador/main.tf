resource "helm_release" "ambassador" {
  depends_on = [kubernetes_secret.lightstep-access-token, kubectl_manifest.ambassador-backend-config, kubectl_manifest.ambassador-backend-config-iap]
  name         = var.name
  namespace    = var.namespace
  repository   = "https://getambassador.io"
  chart        = "ambassador"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    licenseKey  = var.license_key
    promEnabled = var.prom_enabled
    backendConfig = var.backend_config
    name          = var.name
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
  # This doesn't work on the first install
  count      = length(data.kubectl_path_documents.manifests.documents)
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}

resource "kubectl_manifest" "ambassador-backend-config" {
  yaml_body  = file("${path.module}/yaml/k8s-gcp/backend-config.yaml")
}

// IAP
resource "kubectl_manifest" "ambassador-backend-config-iap" {
  yaml_body  = file("${path.module}/yaml/k8s-gcp/backend-config-iap.yaml")
}

resource "kubernetes_service" "ambassador-iap" {
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
  metadata {
    name = "ambassador-iap"
    namespace = var.namespace
    annotations = {
      "cloud.google.com/neg": "{\"ingress\": true}"
      "cloud.google.com/backend-config": "{\"default\": \"${kubectl_manifest.ambassador-backend-config-iap.name}\"}"
      "cloud.google.com/app-protocols": "{\"grpc\": \"HTTP2\"}"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "ambassador"
      "app.kubernetes.io/name" = "ambassador"
    }
    port {
      port        = 8080
      target_port = 8080
      name = "http"
    }
    port {
      port        = 8443
      target_port = 8443
      name = "grpc"
    }

    type = "NodePort"
  }
}


//resource "kubernetes_secret" "ambassador-keycloak-secret" {
//  metadata {
//    name      = "ambassador-keycloak-secret"
//    namespace = var.namespace
//  }
//
//  data = {
//    "oauth2-client-secret" = var.ambassador_keycloak_secret
//  }
//
//  type = "Opaque"
//}
//
//resource "kubernetes_secret" "pepper-poker-keycloak-secret" {
//  metadata {
//    name      = "pepper-poker-keycloak-secret"
//    namespace = var.namespace
//  }
//
//  data = {
//    "oauth2-client-secret" = var.pepper_poker_keycloak_secret
//  }
//
//  type = "Opaque"
//}


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


//resource "kubernetes_secret" "default-keycloak-secret" {
//  metadata {
//    name      = "default-keycloak-secret"
//    namespace = var.namespace
//  }
//
//  data = {
//    "oauth2-client-secret" = var.default_keycloak_secret
//  }
//
//  type = "Opaque"
//}
