# https://www.terraform.io/docs/language/modules/syntax.html

module "ambassador" {
  source     = "./modules/ambassador"
  depends_on = [module.gke, module.common, module.prometheus]
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
  source     = "./modules/kafka"
  depends_on = [module.gke, module.common, module.prometheus]
}
module "grafana" {
  source     = "./modules/grafana"
  depends_on = [module.gke, module.common, module.prometheus]
}
module "keycloak" {
  source     = "./modules/keycloak"
  depends_on = [module.gke, module.common, module.prometheus]
}
module "open-telemetry" {
  source     = "./modules/open-telemetry"
  depends_on = [module.gke, module.common]
}
module "postgres" {
  source     = "./modules/postgres"
  depends_on = [module.gke, module.common]
}
module "prometheus" {
  source     = "./modules/prometheus"
  depends_on = [module.gke, module.common]
}
module "web-static" {
  source     = "./modules/web-static"
  depends_on = [module.gke, module.common, module.prometheus, module.kafka]
}

