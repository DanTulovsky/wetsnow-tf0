resource "kubernetes_config_map" "jaeger_sampling_configuration" {
  metadata {
    name      = "jaeger-sampling-configuration"
    namespace = var.namespace
  }

  data = {
    sampling = "{\"default_strategy\":{\"param\":1,\"type\":\"probabilistic\"}}"
  }
}

