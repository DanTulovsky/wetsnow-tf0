variable "lightstep_access_token" {
  sensitive = true
  type      = string
}

variable "datadog_api_key" {
  sensitive = true
  type      = string
}
variable "namespace" {
  type = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}

variable "gke" {
  type    = bool
  default = false
}
