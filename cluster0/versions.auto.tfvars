# Before updating this, make sure an image with this tag exists.
# TODO: #5 Can this be automatically checked?
ambassador = {
  # Updated on Aug 20, 2023
  app_version   = "3.7.2"
  chart_version = "8.7.2"
}
kubernetes_external_secrets = {
  # Updated on Aug 20, 2023
  app_version = "8.5.5"
}
otel_collector = {
  # Updated on Aug 20, 2023
  app_version = "0.83.0"
}
pronestheus = {
  app_version = "v0.2.0"
}
quote_server = {
  app_version = "0.0.22"
}
web_static = {
  # Also update build_push.sh; but this is pushed automatically via github actions
  # Updated on Aug 20, 2023
  app_version = "0.0.44"
}
