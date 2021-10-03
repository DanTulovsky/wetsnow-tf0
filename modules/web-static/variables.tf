variable "namespace" {
  type = string
}

variable "app_version" {
  type = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}
