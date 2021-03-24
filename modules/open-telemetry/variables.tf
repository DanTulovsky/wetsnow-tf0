variable "lightstep_access_token" {
  sensitive = true
  type      = string
}

variable "datadog_api_key" {
  sensitive = true
  type      = string
}
variable "namespace" {
  type = string
}

variable "prom_enabled" {
  type    = bool
  default = false
}

variable "gke" {
  type    = bool
  default = false
}

variable "kafka" {
  type = map(string)
  default = {
    metrics_receivers  = "[otlp, k8s_cluster, prometheus]"
    metrics_processors = "[memory_limiter, batch]"
    metrics_exporters  = "[otlp/lightstep]"
    trace_receivers    = "[otlp, zipkin, jaeger]"
    trace_processors   = "[memory_limiter, batch, k8s_tagger]"
    trace_exporters    = "[otlp/lightstep]"
  }
}
