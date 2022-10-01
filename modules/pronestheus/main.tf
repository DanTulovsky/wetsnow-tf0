resource "helm_release" "pronestheus" {
  name         = "pronestheus"
  namespace    = var.namespace
  chart        = "${path.module}/helm"
  wait         = true
  force_update = true

  values = [
    templatefile("${path.module}/helm/values.yaml", {
      appVersion       = var.app_version
      honeywellClientID         = var.honeywell_client_id
      honeywellClientSecret     = var.honeywell_client_secret
      honeywellLocationID        = var.honeywell_location_id
      honeywellRefreshToken     = var.honeywell_refresh_token
      nestClientID         = var.nest_client_id
      nestClientSecret     = var.nest_client_secret
      nestProjectID        = var.nest_project_id
      nestRefreshToken     = var.nest_refresh_token
      openWeatherToken = var.open_weather_token
    })
  ]
}
