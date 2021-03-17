variable "service_account" {
  type    = string
  default = "wetsnow-tf0"
}
variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(any)
}


variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type = map(string)
}


variable "cluster_info" {
  type = object({
    name       = string
    vpc_name   = string
    namespaces = set(string)
  })
}

# Postgres Database
# variable "db_users" {
#   type      = map(string)
#   sensitive = true
# }
