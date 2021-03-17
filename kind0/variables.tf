variable "service_account" {
  type    = string
  default = "wetsnow-tf0"
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

# Postgres Database
variable "db_users" {
  type      = map(string)
  sensitive = true
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

# Keycloak
variable "keycloak_secrets" {
  sensitive = true
  type = object({
    admin_password      = string
    management_password = string
  })
}

variable "ambassador_secrets" {
  sensitive = true
  type = object({
    ambassador_keycloak_secret   = string
    default_keycloak_secret      = string
    pepper_poker_keycloak_secret = string
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

# App versions
variable "web_static" {
  type = object({
    app_version = string
  })
}
