variable "service_account" {
  type    = string
  default = "wetsnow-tf0"
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(any)
}


variable "environment" {
  type    = string
  default = "dev"
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

variable "ambassador_secrets" {
  sensitive = true
  type = object({
    license_key = string
  })
}

variable "lightstep_secrets" {
  sensitive = true
  type = object({
    access_token = string
  })
}

# App versions
variable "ambassador" {
  type = object({
    app_version = string
  })
}
variable "argo_rollouts" {
  type = object({
    app_version = string
  })
}
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
