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

variable "port_http" {
  type    = number
  default = 8080
}

variable "port_grpc" {
  type    = number
  default = 8081
}

variable "priority_class" {
  type    = string
  default = ""
}
