variable "license_key" {
  type = string
}

variable "namespace" {
  type = string
}

variable "backend_config" {
  type = string
}

variable "name" {
  type = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}
variable "app_version" {
  type = string
}

variable "chart_version" {
  type = string
}
