variable "namespace" {
  type = string
}

variable "app_version" {
  type = string
}

variable "lightstep_access_token" {
  sensitive = true
  type      = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}
