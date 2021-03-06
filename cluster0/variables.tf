variable "project" {
  type = string
}

variable "credentials_file" {
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
    name     = string
    size     = number
    vpc_name = string
  })

}
