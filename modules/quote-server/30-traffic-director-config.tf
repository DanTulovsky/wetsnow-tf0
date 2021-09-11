resource "google_compute_health_check" "quote-server-grpc-health-check" {
  name = "quote-server-grpc-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  grpc_health_check {
    //    port_name          = "health-check-port"
    port_specification = "USE_SERVING_PORT"
    //    grpc_service_name  = "Quote"
  }
}