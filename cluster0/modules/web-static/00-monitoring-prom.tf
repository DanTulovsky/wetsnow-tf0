# this needs prometheus installed for custom resource definition
resource "kubectl_manifest" "servicemonitor_static_web_monitor" {
  #   depends_on = [module.prometheus.name]

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: static-web-monitor
  namespace: web
  labels:
    release: prometheus
spec:
  namespaceSelector:
    any: true
  selector:
    matchLabels:
      service: static-web-frontend
  endpoints:
    - port: http
YAML
}
