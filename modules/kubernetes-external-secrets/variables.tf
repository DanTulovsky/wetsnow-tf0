variable "namespace" {
  type = string
}

variable "app_version" {
  type = string
}

variable "project_id" {
  type = string
}

variable "service_account" {
  type    = string
  default = "k8s-external-secrets"
}