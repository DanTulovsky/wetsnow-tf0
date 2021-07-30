resource "helm_release" "argo-rollouts" {
  name         = "argo-rollouts"
  namespace    = var.namespace
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-rollouts"
  wait         = true
  force_update = false
  version = var.version

  values = [templatefile("${path.module}/yaml/values.yaml", {
  })]
}

resource "kubectl_manifest" "dashboard-cluster-role" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard/cluster_role.yaml", {
  })
}
resource "kubectl_manifest" "dashboard-cluster-role-binding" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard/cluster_role_binding.yaml", {
    namespace = var.namespace
  })
}
resource "kubectl_manifest" "dashboard-deployment" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard/deployment.yaml", {
    namespace = var.namespace
    argo_version = var.version
  })
}
resource "kubectl_manifest" "dashboard-service" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard/service.yaml", {
    namespace = var.namespace
  })
}
resource "kubectl_manifest" "dashboard-service-account" {
  depends_on = [helm_release.argo-rollouts]
  yaml_body = templatefile("${path.module}/yaml/k8s/dashboard/service_account.yaml", {
    namespace = var.namespace
  })
}
