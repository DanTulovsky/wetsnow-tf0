# Before updating this, make sure an image with this tag exists.
# TODO: #5 Can this be automatically checked?
ambassador = {
  app_version   = "3.1.0"
  chart_version = "8.1.1"
}
kubernetes_external_secrets = {
  app_version = "8.3.0"
}
otel_collector = {
  app_version = "0.83.0"
}
pronestheus = {
  app_version = "v0.2.0"
}
quote_server = {
  app_version = "0.0.22"
}
web_static = {
  # Also update build_push.sh
  app_version = "0.0.44"
}
