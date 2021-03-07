# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance

resource "google_sql_database_instance" "master" {
  # name                = "db2"  # random name, since if deleted, can't be re-used for a week
  database_version    = "POSTGRES_13"
  region              = "us-central1"
  project             = var.project
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]


  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier              = "db-f1-micro"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    # disk_autoresize   = true
    disk_type = "PD_HDD"
    disk_size = 20
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
    database_flags {
      name  = "max_connections"
      value = 1000
    }
    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.self_link
    }
  }
}
