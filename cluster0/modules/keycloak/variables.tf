variable "db_password" {
  type      = string
  sensitive = true
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "management_password" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type = string
}
