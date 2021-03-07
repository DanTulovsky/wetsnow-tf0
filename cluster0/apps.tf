# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "./modules/common"
  depends_on = [module.gke]
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
module "prometheus" {
  source     = "./modules/prometheus"
  depends_on = [module.gke, module.common]
}

module "web-static" {
  source     = "./modules/web-static"
  depends_on = [module.gke, module.common, module.prometheus, module.kafka]
}

