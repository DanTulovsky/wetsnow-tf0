variable "broker" {
  type    = string
  default = "kafka0-headless:9092"
}

variable "cloudhut_license" {
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

variable "kafka_replica_count" {
  type    = number
  default = 1
}
