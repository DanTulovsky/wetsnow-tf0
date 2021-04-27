resource "kubernetes_service_account" "otelcontribcol" {
  metadata {
    name      = "otelcontribcol"
    namespace = var.namespace

    labels = {
      app = "otelcontribcol"
    }
  }
}

resource "kubernetes_cluster_role" "otelcontribcol" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["endpoints", "events", "namespaces", "namespaces/status", "nodes", "nodes/proxy", "nodes/spec", "nodes/stats", "pods", "pods/status", "replicationcontrollers", "replicationcontrollers/status", "resourcequotas", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }
}

resource "kubernetes_cluster_role_binding" "otelcontribcol" {
  metadata {
    name = "otelcontribcol"

    labels = {
      app = "otelcontribcol"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "otelcontribcol"
    namespace = "observability"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "otelcontribcol"
  }
}

