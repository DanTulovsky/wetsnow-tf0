
# this provider doesn't support the List type
locals {
  resource_list = yamldecode(templatefile("${path.module}/yaml/k8s/scope.yaml", {
    namespace = var.namespace
  })).items
}

resource "kubectl_manifest" "weave_scope" {
  count     = length(local.resource_list)
  yaml_body = yamlencode(local.resource_list[count.index])
}
