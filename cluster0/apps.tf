# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source = "../modules/common"
  # depends_on = [module.gke]
  namespaces = var.cluster_info.namespaces
}
module "ambassador" {
  source = "../modules/ambassador"
  # depends_on                   = [module.gke]
  license_key                  = var.ambassador_secrets.license_key
  lightstep_access_token       = var.lightstep_secrets.access_token
  namespace                    = module.common.namespaces.ambassador
  prom_enabled                 = true
  backend_config               = "ambassador-hc-config"
  name                         = "ambassador"
}

module "http-ingress" {
  source     = "../modules/http-ingress"
  depends_on = [module.ambassador]
  namespace  = module.common.namespaces.ambassador
}
# module "kafka" {
#   source           = "./modules/kafka"
#   depends_on       = [module.gke, module.prometheus]
#   cloudhut_license = var.kafka_secrets.cloudhut_license
#   namespace        = module.common.namespaces.kafka
#   kafka_replica_count = 1
# }
module "grafana" {
  source = "../modules/grafana"
//  depends_on     = [module.gke]
  admin_password = var.grafana_secrets.admin_password
  smtp_password  = var.grafana_secrets.smtp_password
  namespace      = module.common.namespaces.monitoring
  oauth_secret = ""
}
module "kyverno" {
  source    = "../modules/kyverno"
  namespace = module.common.namespaces.kyverno
}
//module "keycloak" {
//  source = "../modules/keycloak"
//  # depends_on          = [module.gke]
//  db_password         = var.db_users["bn_keycloak"]
//  admin_password      = var.keycloak_secrets.admin_password
//  management_password = var.keycloak_secrets.management_password
//  namespace           = module.common.namespaces.auth
//}
module "open-telemetry" {
  source = "../modules/open-telemetry"
  # depends_on             = [module.gke]
  lightstep_access_token = var.lightstep_secrets.access_token
  datadog_api_key        = var.datadog_secrets.api_key
  namespace              = module.common.namespaces.observability
  gke                    = true
  cluster_name           = "cluster0"
}
# module "postgres" {
#   source         = "./modules/postgres"
#   depends_on     = [module.gke]
#   admin_password = var.pgadmin_secrets.admin_password
#   namespace      = module.common.namespaces.db
# }
module "prometheus" {
  source = "../modules/prometheus"
  # depends_on             = [module.gke]
  lightstep_access_token = var.lightstep_secrets.access_token
  namespace              = module.common.namespaces.monitoring
  enabled                = true
  cluster_name           = "cluster0"
}
module "quote-server" {
  source                 = "../modules/quote-server"
  depends_on             = [module.common]
  namespace              = module.common.namespaces.web
  app_version            = var.quote_server.app_version
  lightstep_access_token = var.lightstep_secrets.access_token
  priority_class         = module.common.priority_class.high0
}
# module "vector" {
#   source     = "./modules/vector"
#   depends_on = [module.gke, module.prometheus, module.kafka]
#   namespace  = module.common.namespaces.vector
# }
module "scope" {
  source    = "../modules/scope"
  namespace = module.common.namespaces.weave
}
module "web-static" {
  source = "../modules/web-static"
  # depends_on             = [module.gke]
  namespace              = module.common.namespaces.web
  app_version            = var.web_static.app_version
  lightstep_access_token = var.lightstep_secrets.access_token
}

