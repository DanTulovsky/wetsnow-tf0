# This secret gets copied to all namespaces
resource "kubernetes_secret" "x-namespace-secret0" {
  metadata {
    name      = "x-namespace-secret0"
    namespace = "default"
  }

  data = {
    "password" = "some-supoer-secret-password-goes-here"
  }

  type = "Opaque"
}
