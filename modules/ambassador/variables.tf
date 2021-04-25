
variable "ambassador_keycloak_secret" {
  type      = string
  sensitive = true
}
variable "default_keycloak_secret" {
  type      = string
  sensitive = true
}
variable "license_key" {
  type      = string
  sensitive = true
}
variable "pepper_poker_keycloak_secret" {
  type      = string
  sensitive = true
}

variable "lightstep_access_token" {
  type      = string
  sensitive = true
}
variable "namespace" {
  type = string
}

variable "backend_config" {
  type= string
}

variable "name" {
  type= string
}

variable "id" {
  type= string
}
variable "gke" {
  description = "set to true on gke"
  type        = bool
  default     = false
}

variable "prom_enabled" {
  type    = bool
  default = false
}
