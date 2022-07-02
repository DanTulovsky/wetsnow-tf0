# Before updating this, make sure an image with this tag exists.
# TODO: #5 Can this be automatically checked?
ambassador = {
  app_version = "1.14.3"
}
argo_events = {
  app_version = "v1.6.0"
}
argo_rollouts = {
  app_version = "v1.2.0-rc1"
}
argo_workflows = {
  app_version = "v3.3.0-rc4"
}
grafana = {
  app_version = "9.0.2"
}
kubernetes_external_secrets = {
  app_version = "8.3.0"
}
otel_collector = {
  app_version = "0.43.0"
}
prometheus = {
  operator_version     = "0.54.0-debian-10-r9"
  otel_sidecar_version = "v0.27.0"
}
quote_server = {
  app_version = "0.0.22"
}
web_static = {
  app_version = "0.0.43"
}
