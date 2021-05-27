//resource "helm_release" "argo-rollouts" {
//  name         = "argo-rollouts"
//  namespace    = var.namespace
//  repository   = "https://argoproj.github.io/argo-helm"
//  chart        = "argo-rollouts"
//  wait         = true
//  force_update = false
//
//  values = [templatefile("${path.module}/yaml/values.yaml", {
//    tag: "v1.0.0"
//  })]
//}

// Until the helm chart supports v1.0
resource "kubectl_manifest" "argo-rollouts" {
  yaml_body  = templatefile("${path.module}/yaml/k8s/argo.yaml", {
    namespace = var.namespace
  })
}
