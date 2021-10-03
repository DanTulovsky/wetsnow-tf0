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
variable "operator_version" {
  type = string
}
variable "otel_sidecar_version" {
  type = string
}
