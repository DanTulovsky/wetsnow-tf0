# https://argoproj.github.io/argo-rollouts/migrating/
resource "kubectl_manifest" "quote-server-rollout" {
  depends_on = [
    kubernetes_deployment_v1.quote_server_grpc
  ]
  yaml_body = file("${path.module}/yaml/k8s/rollout.yaml")
}
