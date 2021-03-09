variable "db_password" {
  type      = string
  sensitive = true
}

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
