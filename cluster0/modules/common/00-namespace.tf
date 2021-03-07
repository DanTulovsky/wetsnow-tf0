resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}
