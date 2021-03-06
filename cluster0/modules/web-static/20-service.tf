resource "kubectl_manifest" "service_static_web_frontend" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: static-web-frontend
  namespace: web
  labels:
    app: "static-web"
    component: frontend
    tier: production
    service: static-web-frontend
spec:
  ports:
    - port: 8080
      name: http
      protocol: TCP
      targetPort: http
  selector:
    app: static-web
    component: frontend
    tier: production
  sessionAffinity: None # or ClientIP
  type: ClusterIP
  clusterIP: None # headless service
YAML
}
