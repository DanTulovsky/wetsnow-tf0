resource "kubernetes_priority_class" "low0" {
  metadata {
    name = "lowhigh0"
  }

  value = 10
}

resource "kubernetes_priority_class" "high0" {
  metadata {
    name = "high0"
  }

  value = 100000
}
