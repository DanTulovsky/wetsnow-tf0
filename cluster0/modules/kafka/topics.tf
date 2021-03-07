
# https://github.com/Mongey/terraform-provider-kafka
# resource "kafka_topic" "otlp_metrics" {
#   provider           = kafka
#   depends_on         = [helm_release.kafka]
#   name               = "otlp_metrics"
#   replication_factor = 1
#   partitions         = 1

#   config = {
#     "cleanup.policy" = "compact"
#     "compression.type" : "gzip"
#   }
# }

# resource "kafka_topic" "otpl_spans" {
#   depends_on         = [helm_release.kafka]
#   name               = "otpl_spans"
#   replication_factor = 1
#   partitions         = 1

#   config = {
#     "cleanup.policy" = "compact"
#     "compression.type" : "gzip"
#   }
# }

# resource "kafka_topic" "kube-logs" {
#   depends_on         = [helm_release.kafka]
#   name               = "test0"
#   replication_factor = 1
#   partitions         = 1

#   config = {
#     "cleanup.policy" = "compact"
#     "compression.type" : "gzip"
#   }
# }
