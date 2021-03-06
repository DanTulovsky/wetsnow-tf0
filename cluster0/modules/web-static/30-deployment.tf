resource "kubectl_manifest" "deployment_frontend" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: static-web
      component: frontend
      tier: production
  strategy:
    type: RollingUpdate
    # rollingUpdate:
    #   maxSurge: 25%
    #   maxUnavailable: 25%
  template:
    metadata:
      labels:
        app: static-web
        component: frontend
        tier: production
        # version: "2020020600"
    spec:
      containers:
        - name: frontend
          image: ghcr.io/dantulovsky/web-static/frontend
          args:
            [
              "--data_dir",
              "/data/hosts",
              "--enable_logging",
              "--enable_tracing",
            ]
          resources:
            limits:
              cpu: "0.1"
              memory: "20Mi"
            requests:
              cpu: "0.1"
              memory: "20Mi"
          ports:
            - containerPort: 8080
              name: http
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
              httpHeaders:
                - name: X-Healthz-Prober
                  value: liveliness
            periodSeconds: 5
            initialDelaySeconds: 5
          readinessProbe:
            httpGet:
              path: /servez
              port: 8080
              httpHeaders:
                - name: X-Healthz-Prober
                  value: readiness
            periodSeconds: 5
            initialDelaySeconds: 5
YAML
}
