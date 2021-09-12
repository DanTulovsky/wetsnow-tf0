# Bind the web/default service account to a new IAM account with proper permissions
# Required if using workload identity
# gcloud iam service-accounts create k8s-web-default
# gcloud projects add-iam-policy-binding snowcloud-01 --member serviceAccount:k8s-web-default@snowcloud-01.iam.gserviceaccount.com --role roles/trafficdirector.client
# gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:snowcloud-01.svc.id.goog[web/default]" k8s-web-default@snowcloud-01.iam.gserviceaccount.comk -n web annotate serviceaccount --namespace web default iam.gke.io/gcp-service-account=k8s-web-default@snowcloud-01.iam.gserviceaccount.com

# Health check
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
resource "google_compute_health_check" "quote-server-grpc-health-check" {
  provider = google-beta
  name     = "quote-server-grpc-health-check"

  timeout_sec        = 1
  check_interval_sec = 1
  log_config {
    enable = true
  }

  grpc_health_check {
    //    port_name          = "health-check-port"
    grpc_service_name  = "grpc.health.v1.Health"
    port_specification = "USE_SERVING_PORT"
    # TODO: Automate
    //    port = var.port_grpc
  }
}

# Firewall rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "quote-server-grpc-gke-allow-health-checks" {
  provider = google-beta
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
      var.port_grpc,
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
  provider = google-beta
  name     = "quote-server-grpc-backend-service"
  health_checks = [
    google_compute_health_check.quote-server-grpc-health-check.id
  ]
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  protocol              = "GRPC"
  backend {
    # TODO: Automate; get from neg-status annotation on Service
    group                 = "projects/snowcloud-01/zones/us-central1-c/networkEndpointGroups/k8s1-c5c88bb8-web-quote-server-grpc-8081-dde5610f"
    balancing_mode        = "RATE"
    max_rate_per_endpoint = 5
  }
  log_config {
    enable = true
  }
}

# url-map
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
resource "google_compute_url_map" "quote-server-urlmap" {
  provider        = google-beta
  name            = "quote-server-urlmap"
  description     = "quote server grpc url map"
  default_service = google_compute_backend_service.quote-server-backend-service.id

  host_rule {
    hosts = [
      # arbitrary name and port used by the client to lookup this mapping
      # TODO: Automate to share with client
      "quote-server-gke:8000"
    ]
    path_matcher = "grpc-gke-path-matcher"
  }
  path_matcher {
    name            = "grpc-gke-path-matcher"
    default_service = google_compute_backend_service.quote-server-backend-service.id

    path_rule {
      service = google_compute_backend_service.quote-server-backend-service.id
      paths = [
        "/"
      ]
      //      route_action {}
    }
  }
}

#  target gRPC proxy
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_grpc_proxy
resource "google_compute_target_grpc_proxy" "quote-server-grpc-proxy" {
  provider               = google-beta
  name                   = "proxy"
  url_map                = google_compute_url_map.quote-server-urlmap.id
  validate_for_proxyless = true
}

# forwarding rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
resource "google_compute_global_forwarding_rule" "quote-server-forwarding-rule" {
  provider              = google-beta
  name                  = "quote-server-l7-forwarding-rule"
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  port_range            = "8000"
  target                = google_compute_target_grpc_proxy.quote-server-grpc-proxy.id
  # required for grpc proxy
  ip_address  = "0.0.0.0"
  ip_protocol = "TCP"
  # TODO: Automate
  network = "vpc0"
  project = "snowcloud-01"
}