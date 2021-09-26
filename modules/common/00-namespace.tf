resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespaces

  metadata {
    name = each.key
  }
}

