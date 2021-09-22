variable "oauth_secret" {
  type      = string
  sensitive = true
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "smtp_password" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}

variable "app_version" {
  type = string
}
