# https://www.terraform.io/docs/language/modules/syntax.html

module "common" {
  source     = "../modules/common"
  namespaces = var.cluster_info.namespaces
  project_id = var.project
  # This token gets written to "lightstep-access-token" in Google Secret Manager
  lightstep_access_token = var.lightstep_secrets.access_token
}
module "ambassador" {
  source         = "../modules/ambassador"
  license_key    = var.ambassador_secrets.license_key
  namespace      = module.common.namespaces.ambassador
  backend_config = "ambassador-hc-config"
  name           = "ambassador"
  app_version    = var.ambassador.app_version
}

module "argo" {
  source       = "../modules/argo"
  namespace    = module.common.namespaces.argo-rollouts
  argo_version = var.argo_rollouts.app_version
}

module "http-ingress" {
  source = "../modules/http-ingress"
  depends_on = [
    module.ambassador
  ]
  namespace = module.common.namespaces.ambassador
}
module "grafana" {
  source         = "../modules/grafana"
  admin_password = var.grafana_secrets.admin_password
  smtp_password  = var.grafana_secrets.smtp_password
  namespace      = module.common.namespaces.monitoring
  prom_enabled   = false
  oauth_secret   = ""
  app_version    = var.grafana.app_version
}
module "kubernetes-external-secrets" {
  source      = "../modules/kubernetes-external-secrets"
  namespace   = module.common.namespaces.security
  app_version = var.kubernetes_external_secrets.app_version
  project_id  = var.project
}
//module "kyverno" {
//  source    = "../modules/kyverno"
//  namespace = module.common.namespaces.kyverno
//}

module "nobl9" {
  source    = "../modules/nobl9"
  namespace = module.common.namespaces.monitoring
}

module "open-telemetry" {
  source        = "../modules/open-telemetry"
  namespace     = module.common.namespaces.observability
  gke           = true
  cluster_name  = var.cluster_info.name
  prom_enabled  = true
  image_version = var.otel_collector.app_version
}
# module "postgres" {
#   source         = "./modules/postgres"
#   depends_on     = [module.gke]
#   admin_password = var.pgadmin_secrets.admin_password
#   namespace      = module.common.namespaces.db
# }
#module "parca" {
#  source    = "../modules/parca"
#  namespace = module.common.namespaces.parca
#}
#module "prometheus" {
#  source               = "../modules/prometheus"
#  namespace            = module.common.namespaces.monitoring
#  enabled              = true
#  cluster_name         = var.cluster_info.name
#  operator_version     = var.prometheus.operator_version
#  otel_sidecar_version = var.prometheus.otel_sidecar_version
#}
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
# module "vector" {
#   source     = "./modules/vector"
#   depends_on = [module.gke, module.prometheus, module.kafka]
#   namespace  = module.common.namespaces.vector
# }
module "web-static" {
  source       = "../modules/web-static"
  namespace    = module.common.namespaces.web
  app_version  = var.web_static.app_version
  prom_enabled = false
}

