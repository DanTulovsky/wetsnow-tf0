# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "../modules/common"
  namespaces = var.cluster_info.namespaces
  project_id = var.project
  # This token gets written to "lightstep-access-token" in Google Secret Manager
  lightstep_access_token = var.lightstep_secrets.access_token
}
#module "kyverno" {
#  source    = "../modules/kyverno"
#  namespace = module.common.namespaces.kyverno
#}

module "grafana" {
  source         = "../modules/grafana"
  oauth_secret   = var.grafana_secrets.oauth_secret
  admin_password = var.grafana_secrets.admin_password
  smtp_password  = var.grafana_secrets.smtp_password
  namespace      = module.common.namespaces.monitoring
  app_version    = var.grafana.app_version
}

module "open-telemetry" {
  source        = "../modules/open-telemetry"
  depends_on    = [module.common]
  namespace     = module.common.namespaces.observability
  image_version = var.otel_collector.app_version
  otel = {
    metrics_receivers  = "[otlp, k8s_cluster]"
    metrics_processors = "[memory_limiter, batch]"
    metrics_exporters  = "[otlp/lightstep, kafka]"
    trace_receivers    = "[otlp, zipkin, jaeger]"
    trace_processors   = "[memory_limiter, batch, k8s_tagger]"
    trace_exporters    = "[otlp/lightstep, kafka]"
  }
  cluster_name = "kind0"
}

module "prometheus" {
  source               = "../modules/prometheus"
  depends_on           = [module.common]
  namespace            = module.common.namespaces.monitoring
  enabled              = true
  cluster_name         = "kind0"
  operator_version     = var.prometheus.operator_version
  otel_sidecar_version = var.prometheus.otel_sidecar_version
}

module "quote-server" {
  source         = "../modules/quote-server"
  depends_on     = [module.common]
  namespace      = module.common.namespaces.web
  app_version    = var.quote_server.app_version
  priority_class = module.common.priority_class.high0
}

#module "vector" {
#  source     = "../modules/vector"
#  namespace  = module.common.namespaces.vector
#}
module "web-static" {
  source      = "../modules/web-static"
  depends_on  = [module.common]
  namespace   = module.common.namespaces.web
  app_version = var.web_static.app_version
}

