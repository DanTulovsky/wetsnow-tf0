output "namespaces" {
  value = tomap({
    for k, v in kubernetes_namespace.namespaces : k => v.metadata[0].name
  })
}
