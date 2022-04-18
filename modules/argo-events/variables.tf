variable "namespace" {
  type = string
}

variable "argo_version" {
  type = string
}

variable "all_namespaces" {
  type    = set(any)
  default = []
}
