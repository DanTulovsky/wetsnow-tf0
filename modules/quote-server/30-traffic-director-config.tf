# Health check
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
resource "google_compute_health_check" "quote-server-grpc-health-check" {
  name = "quote-server-grpc-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  grpc_health_check {
    //    port_name          = "health-check-port"
    //    grpc_service_name  = "Quote"
    port_specification = "USE_SERVING_PORT"
  }
}

# Firewall rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "quote-server-grpc-gke-allow-health-checks" {
  # TODO: set automatically
  project = "snowcloud-01"
  name    = "grpc-gke-allow-health-checks"
  # TODO: set automatically
  network     = "vpc0"
  description = "Allow health checks to grpc port 8081"
  direction   = "INGRESS"

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]

  allow {
    protocol = "tcp"
    ports = [
      # TODO: set automatically
      "8081",
    ]
  }

  target_tags = [
    # Set on nodes via gke.tf
    "allow-health-checks"
  ]
}

# Backend service
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "quote-server-backend-service" {
  name = "backend-service"
  health_checks = [
    google_compute_health_check.quote-server-grpc-health-check.id
  ]
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  protocol              = "GRPC"
}