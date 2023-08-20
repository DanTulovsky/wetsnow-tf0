# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "../modules/common"
  namespaces = var.cluster_info.namespaces
  project_id = var.project
  # This token gets written to "lightstep-access-token" in Google Secret Manager
  # lightstep_access_token = var.lightstep_secrets.access_token
  #  lightstep_access_token = var.lightstep_secrets.access_token
}
module "ambassador" {
  source = "../modules/ambassador"
  #  license_key    = var.ambassador_secrets.license_key
  license_key    = module.common.ambassador_license_key
  namespace      = module.common.namespaces.ambassador
  backend_config = "ambassador-hc-config"
  name           = "ambassador"
  app_version    = var.ambassador.app_version
  chart_version  = var.ambassador.chart_version
}
module "http-ingress" {
  source = "../modules/http-ingress"
  depends_on = [
    module.ambassador
  ]
  namespace = module.common.namespaces.ambassador
}

module "kube-state-metrics" {
  source    = "../modules/kube-state-metrics"
  namespace = module.common.namespaces.monitoring
}

module "kubernetes-external-secrets" {
  source      = "../modules/kubernetes-external-secrets"
  namespace   = module.common.namespaces.security
  app_version = var.kubernetes_external_secrets.app_version
  project_id  = var.project
}

module "nobl9" {
  source         = "../modules/nobl9"
  namespace      = module.common.namespaces.monitoring
  jira_api_token = module.common.nobl9_jira_api_token
}

module "open-telemetry" {
  source        = "../modules/open-telemetry"
  namespace     = module.common.namespaces.observability
  gke           = true
  cluster_name  = var.cluster_info.nam
  prom_enabled  = true
  image_version = var.otel_collector.app_version
}

module "pronestheus" {
  source                  = "../modules/pronestheus"
  namespace               = module.common.namespaces.observability
  app_version             = var.pronestheus.app_version
  honeywell_refresh_token = module.common.honeywell_refresh_token
  honeywell_client_id     = module.common.honeywell_client_id
  honeywell_client_secret = module.common.honeywell_client_secret
  honeywell_location_id   = "2816484" // 962 N Mountain Rd Kitchen
  nest_refresh_token      = module.common.nest_refresh_token
  nest_client_id          = module.common.nest_client_id
  nest_client_secret      = module.common.nest_client_secret
  nest_project_id         = module.common.nest_project_id
  open_weather_token      = module.common.open_weather_token
}
module "quote-server" {
  source = "../modules/quote-server"
  depends_on = [
    module.common
  ]
  namespace      = module.common.namespaces.web
  app_version    = var.quote_server.app_version
  priority_class = module.common.priority_class.high0
  prom_enabled   = false
}
module "web-static" {
  source       = "../modules/web-static"
  namespace    = module.common.namespaces.web
  app_version  = var.web_static.app_version
  prom_enabled = false
}

