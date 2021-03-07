
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kafka = {
      source = "Mongey/kafka"
    }
  }
}

resource "helm_release" "kafka" {
  name         = "kafka0"
  namespace    = "kafka"
  repository   = "https://charts.bitnami.com/bitnami"
  chart        = "kafka"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {})]
}

resource "helm_release" "kowl" {
  depends_on   = [helm_release.kafka]
  name         = "kowl"
  namespace    = "kafka"
  repository   = "https://raw.githubusercontent.com/cloudhut/charts/master/archives"
  chart        = "kowl"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/kowl-values.yaml", {
    kowlSecret = kubernetes_secret.kowl.metadata[0].name
    broker     = var.broker
  })]
}

resource "kubernetes_secret" "kowl" {
  metadata {
    name      = "kowl"
    namespace = "kafka"
  }

  data = {
    kafka-sasl-password : ""
    kafka-tls-ca : ""
    kafka-tls-cert : ""
    kafka-tls-key : ""
    kafka-tls-passphrase : ""
    cloudhut-license-token : file("${path.module}/.secret/cloudhut-license-token.yaml")
    login-jwt-secret : ""
    login-google-oauth-client-secret : ""
    "login-google-groups-service-account.json" : ""
    login-github-oauth-client-secret : ""
    login-github-personal-access-token : ""
  }

  type = "Opaque"
}
