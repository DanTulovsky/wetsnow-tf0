output "namespaces" {
  value = tomap({
    for k, v in kubernetes_namespace.namespaces : k => v.metadata[0].name
  })
}

output "priority_class" {
  value = {
    "low0" : kubernetes_priority_class.low0.metadata[0].name
    "high0" : kubernetes_priority_class.high0.metadata[0].name
  }
}
