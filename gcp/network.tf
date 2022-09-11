
resource "google_compute_network" "vpc_network" {
  name                    = var.cluster_info.vpc_name
  auto_create_subnetworks = false
}