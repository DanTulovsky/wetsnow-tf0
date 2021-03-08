# https://www.terraform.io/docs/language/modules/syntax.html

module "ambassador" {
  source                       = "./modules/ambassador"
  depends_on                   = [module.gke, module.common, module.prometheus]
  ambassador_keycloak_secret   = var.ambassador_secrets.ambassador_keycloak_secret
  default_keycloak_secret      = var.ambassador_secrets.default_keycloak_secret
  pepper_poker_keycloak_secret = var.ambassador_secrets.pepper_poker_keycloak_secret
  license_key                  = var.ambassador_secrets.license_key
}
module "common" {
  source     = "./modules/common"
  depends_on = [module.gke]
}
module "http-ingress" {
  source     = "./modules/http-ingress"
  depends_on = [module.gke, module.common, module.ambassador]
}
module "kafka" {
  source           = "./modules/kafka"
  depends_on       = [module.gke, module.common, module.prometheus]
  cloudhut_license = var.kafka_secrets.cloudhut_license
}
module "grafana" {
  source         = "./modules/grafana"
  depends_on     = [module.gke, module.common, module.prometheus]
  db_password    = var.db_users["grafana"]
  oauth_secret   = var.grafana_secrets.oauth_secret
  admin_password = var.grafana_secrets.admin_password
  smtp_password  = var.grafana_secrets.smtp_password
}
module "keycloak" {
  source              = "./modules/keycloak"
  depends_on          = [module.gke, module.common, module.prometheus]
  db_password         = var.db_users["bn_keycloak"]
  admin_password      = var.keycloak_secrets.admin_password
  management_password = var.keycloak_secrets.management_password
}
module "open-telemetry" {
  source                 = "./modules/open-telemetry"
  depends_on             = [module.gke, module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
}
module "postgres" {
  source         = "./modules/postgres"
  depends_on     = [module.gke, module.common]
  admin_password = var.pgadmin_secrets.admin_password
}
module "prometheus" {
  source                 = "./modules/prometheus"
  depends_on             = [module.gke, module.common]
  lightstep_access_token = var.lightstep_secrets.access_token
}
module "vector" {
  source     = "./modules/vector"
  depends_on = [module.gke, module.common, module.prometheus, module.kafka]
}
module "web-static" {
  source     = "./modules/web-static"
  depends_on = [module.gke, module.common, module.prometheus, module.kafka]
}

