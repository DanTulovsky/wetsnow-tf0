variable "broker" {
  type    = string
  default = "kafka0-headless:9092"
}

variable "cloudhut_license" {
  type      = string
  sensitive = true
}
