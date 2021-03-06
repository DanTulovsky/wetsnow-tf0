# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "./modules/common"
  depends_on = [module.gke.name]
}

module "prometheus" {
  source     = "./modules/prometheus"
  depends_on = [module.gke.nameb]
}

module "web-static" {
  source     = "./modules/web-static"
  depends_on = [module.gke.name, module.common.namespace_web, module.prometheus.name]
}

