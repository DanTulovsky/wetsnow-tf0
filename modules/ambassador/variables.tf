
variable "license_key" {
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

variable "prom_enabled" {
  type    = bool
  default = false
}
