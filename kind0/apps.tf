# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "../modules/common"
  namespaces = var.cluster_info.namespaces
}
module "kyverno" {
  source    = "../modules/kyverno"
  namespace = module.common.namespaces.kyverno
}

module "grafana" {
  source         = "../modules/grafana"
  oauth_secret   = var.grafana_secrets.oauth_secret
  admin_password = var.grafana_secrets.admin_password
  smtp_password  = var.grafana_secrets.smtp_password
  namespace      = module.common.namespaces.monitoring
}

module "open-telemetry" {
  source                 = "../modules/open-telemetry"
  depends_on             = [module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
  datadog_api_key        = var.datadog_secrets.api_key
  namespace              = module.common.namespaces.observability
  otel                   = {
    metrics_receivers  = "[otlp, k8s_cluster]"
    metrics_processors = "[memory_limiter, batch]"
    metrics_exporters  = "[otlp/lightstep, kafka]"
    trace_receivers    = "[otlp, zipkin, jaeger]"
    trace_processors   = "[memory_limiter, batch, k8s_tagger]"
    trace_exporters    = "[otlp/lightstep, kafka]"
  }
  cluster_name           = "kind0"
}

module "prometheus" {
  source                 = "../modules/prometheus"
  depends_on             = [module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
  namespace              = module.common.namespaces.monitoring
  enabled                = true
  cluster_name           = "kind0"
}

module "quote-server" {
  source                 = "../modules/quote-server"
  depends_on             = [module.common]
  namespace              = module.common.namespaces.web
  app_version            = var.quote_server.app_version
  lightstep_access_token = var.lightstep_secrets.access_token
  priority_class         = module.common.priority_class.high0
}

module "scope" {
  source    = "../modules/scope"
  namespace = module.common.namespaces.weave
}
module "vector" {
  source     = "../modules/vector"
  depends_on = [module.kafka]
  namespace  = module.common.namespaces.vector
}
module "web-static" {
  source                 = "../modules/web-static"
  depends_on             = [module.common]
  namespace              = module.common.namespaces.web
  app_version            = var.web_static.app_version
  lightstep_access_token = var.lightstep_secrets.access_token
}

