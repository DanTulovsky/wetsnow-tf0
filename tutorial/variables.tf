variable "project" {
  type = string
}

variable "credentials_file" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type = map(string)
}
