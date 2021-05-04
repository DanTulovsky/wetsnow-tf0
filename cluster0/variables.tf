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
    license_key                  = string
  })
}

variable "lightstep_secrets" {
  sensitive = true
  type = object({
    access_token = string
  })
}

variable "datadog_secrets" {
  sensitive = true
  type = object({
    api_key = string
  })
}
variable "pgadmin_secrets" {
  sensitive = true
  type = object({
    admin_password = string
  })
}

variable "kafka_secrets" {
  sensitive = true
  type = object({
    cloudhut_license = string
  })
}

variable "traefik_secrets" {
  sensitive = true
  type = object({
    token                  = string
  })
}
variable "quote_server" {
  type = object({
    app_version = string
  })
}
# App versions
variable "web_static" {
  type = object({
    app_version = string
  })
}
