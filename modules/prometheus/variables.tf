variable "lightstep_access_token" {
  sensitive = true
  type      = string
}

variable "namespace" {
  type = string
}

variable "enabled" {
  default = false
  type    = bool
}
variable "cluster_name" {
  type = string
}
