resource "kubernetes_namespace" "ambassador" {
  metadata {
    name = "ambassador"
  }
}
resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }
}

resource "kubernetes_namespace" "db" {
  metadata {
    name = "db"
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
resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}
resource "kubernetes_namespace" "vector" {
  metadata {
    name = "vector"
  }
}
resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}
