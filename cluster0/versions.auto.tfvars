# Before updating this, make sure an image with this tag exists.
# TODO: #5 Can this be automatically checked?
ambassador = {
  app_version = "1.14.2"
}
argo_rollouts = {
  app_version = "v1.1.1"
}
grafana = {
  app_version = "8.3.4"
}
kubernetes_external_secrets = {
  app_version = "8.3.0"
}
otel_collector = {
  app_version = "0.43.0"
}
prometheus = {
  operator_version     = "0.50.0-debian-10-r30"
  otel_sidecar_version = "v0.27.0"
}
quote_server = {
  app_version = "0.0.22"
}
web_static = {
  app_version = "0.0.43"
}
