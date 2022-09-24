variable "namespace" {
  type = string
}

variable "cluster_name" {
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

variable "image_version" {
  type = string
}

variable "otel" {
  type = map(string)
  default = {
    metrics_receivers  = "[otlp, statsd, k8s_cluster, prometheus]"
    metrics_processors = "[memory_limiter, batch]"
    metrics_exporters  = "[otlp/lightstep]"
    trace_receivers    = "[otlp, zipkin, jaeger]"
    trace_processors   = "[memory_limiter, batch, k8sattributes, servicegraph]"
    trace_exporters    = "[otlp/lightstep]"
  }
}
