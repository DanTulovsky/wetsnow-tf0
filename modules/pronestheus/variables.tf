variable "namespace" {
  type = string
}

variable "app_version" {
  type = string
}

variable "nest_refresh_token" {
  type      = string
  sensitive = true
}
variable "nest_client_secret" {
  type      = string
  sensitive = true
}
variable "nest_client_id" {
  type      = string
  sensitive = true
}
variable "nest_project_id" {
  type      = string
  sensitive = true
}
variable "open_weather_token" {
  type      = string
  sensitive = true
}
