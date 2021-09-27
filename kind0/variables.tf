variable "service_account" {
  type    = string
  default = "wetsnow-tf0"
}

variable "project" {
  type    = string
  default = "unset_project"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type = map(string)
}


variable "cluster_info" {
  type = object({
    name       = string
    vpc_name   = string
    namespaces = set(string)
  })
}

# Grafana
variable "grafana_secrets" {
  sensitive = true
  type = object({
    oauth_secret   = string
    admin_password = string
    smtp_password  = string
  })
}

variable "lightstep_secrets" {
  sensitive = true
  type = object({
    access_token = string
  })
}

# App versions
variable "grafana" {
  type = object({
    app_version = string
  })
}
variable "kubernetes_external_secrets" {
  type = object({
    app_version = string
  })
}
variable "otel_collector" {
  type = object({
    app_version = string
  })
}
variable "prometheus" {
  type = object({
    operator_version     = string
    otel_sidecar_version = string
  })
}
variable "quote_server" {
  type = object({
    app_version = string
  })
}
variable "web_static" {
  type = object({
    app_version = string
  })
}
