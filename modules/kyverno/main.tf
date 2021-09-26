
resource "helm_release" "kyverno" {
  name         = "kyverno"
  namespace    = var.namespace
  repository   = "https://kyverno.github.io/kyverno/"
  chart        = "kyverno"
  wait         = true
  force_update = false

  values = [templatefile("${path.module}/yaml/values.yaml", {
    namespace = var.namespace
  })]
}

resource "kubectl_manifest" "require-labels-yaml" {
  depends_on = [helm_release.kyverno]
  yaml_body = templatefile("${path.module}/policies/require-labels.yaml", {
    validationFailureActions = "audit" # or 'enforce'
  })
}

resource "kubectl_manifest" "x-namespace-secrets-yaml" {
  depends_on = [helm_release.kyverno]
  yaml_body  = file("${path.module}/policies/x-namespace-secrets.yaml")
}

resource "kubectl_manifest" "quote-server-max-pods" {
  depends_on = [helm_release.kyverno]
  yaml_body  = file("${path.module}/policies/quote-server-max-pods.yaml")
}
