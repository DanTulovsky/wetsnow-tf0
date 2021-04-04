# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "../modules/common"
  namespaces = var.cluster_info.namespaces
}
module "ambassador" {
  source                       = "../modules/ambassador"
  depends_on                   = [module.common]
  ambassador_keycloak_secret   = var.ambassador_secrets.ambassador_keycloak_secret
  default_keycloak_secret      = var.ambassador_secrets.default_keycloak_secret
  pepper_poker_keycloak_secret = var.ambassador_secrets.pepper_poker_keycloak_secret
  license_key                  = var.ambassador_secrets.license_key
  lightstep_access_token       = var.lightstep_secrets.access_token
  namespace                    = module.common.namespaces.ambassador
  prom_enabled                 = false
}
# module "http-ingress" {
#   source     = "./modules/http-ingress"
#   depends_on = [module.gke, module.ambassador]
#   namespace  = module.common.namespaces.ambassador
# }
module "kafka" {
  source              = "../modules/kafka"
  cloudhut_license    = var.kafka_secrets.cloudhut_license
  namespace           = module.common.namespaces.kafka
  prom_enabled        = false
  kafka_replica_count = 1
}
module "kyverno" {
  source    = "../modules/kyverno"
  namespace = module.common.namespaces.kyverno
}
# module "grafana" {
#   source         = "./modules/grafana"
#   depends_on     = [module.gke]
#   db_password    = var.db_users["grafana"]
#   oauth_secret   = var.grafana_secrets.oauth_secret
#   admin_password = var.grafana_secrets.admin_password
#   smtp_password  = var.grafana_secrets.smtp_password
#   namespace      = module.common.namespaces.monitoring
# }
# module "keycloak" {
#   source              = "./modules/keycloak"
#   depends_on          = [module.gke]
#   db_password         = var.db_users["bn_keycloak"]
#   admin_password      = var.keycloak_secrets.admin_password
#   management_password = var.keycloak_secrets.management_password
#   namespace           = module.common.namespaces.auth
# }
module "open-telemetry" {
  source                 = "../modules/open-telemetry"
  depends_on             = [module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
  datadog_api_key        = var.datadog_secrets.api_key
  namespace              = module.common.namespaces.observability
  kafka = {
    metrics_receivers  = "[otlp, k8s_cluster]"
    metrics_processors = "[memory_limiter, batch]"
    metrics_exporters  = "[otlp/lightstep, kafka]"
    trace_receivers    = "[otlp, zipkin, jaeger]"
    trace_processors   = "[memory_limiter, batch, k8s_tagger]"
    trace_exporters    = "[otlp/lightstep, kafka]"
  }
}
# module "postgres" {
#   source         = "./modules/postgres"
#   depends_on     = [module.gke]
#   admin_password = var.pgadmin_secrets.admin_password
#   namespace      = module.common.namespaces.db
# }
module "prometheus" {
  source                 = "../modules/prometheus"
  depends_on             = [module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
  namespace              = module.common.namespaces.monitoring
  enabled                = true
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

