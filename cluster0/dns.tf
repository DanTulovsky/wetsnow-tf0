module "dns-private-zone" {
  source     = "terraform-google-modules/cloud-dns/google"
  version    = "3.0.0"
  project_id = var.project
  type       = "private"
  name       = "gke-internal-wetsnow-com"
  domain     = "gke-internal.wetsnow.com."

  private_visibility_config_networks = [
    # google_compute_network.vpc_network.self_link,
    "projects/snowcloud-01/global/networks/vpc0",
  ]

  recordsets = [
    {
      name = "localhost"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = "db1"
      type = "A"
      ttl  = 300
      records = [
        google_sql_database_instance.master.private_ip_address
      ]
    },
  ]
}
