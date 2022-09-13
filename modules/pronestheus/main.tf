resource "helm_release" "pronestheus" {
  name         = "pronestheus"
  namespace    = var.namespace
  chart        = "${path.module}/helm"
  wait         = true
  force_update = true

  values = [
    templatefile("${path.module}/helm/values.yaml", {
      appVersion       = var.app_version
      clientID         = var.nest_client_id
      clientSecret     = var.nest_client_secret
      projectID        = var.nest_project_id
      refreshToken     = var.nest_refresh_token
      openWeatherToken = var.open_weather_token
    })
  ]
}
