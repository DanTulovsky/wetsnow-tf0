
module "gke" {
  depends_on = [google_sql_database_instance.master]

  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "13.1.0"
  project_id                 = var.project
  name                       = var.cluster_info.name
  region                     = var.region
  regional                   = false
  release_channel            = "RAPID"
  zones                      = var.zones
  network                    = var.cluster_info.vpc_name
  subnetwork                 = var.cluster_info.vpc_name
  enable_shielded_nodes      = true
  ip_range_pods              = "" # defaults
  ip_range_services          = "" # defaults
  http_load_balancing        = true
  horizontal_pod_autoscaling = false
  logging_service            = "logging.googleapis.com/kubernetes"
  monitoring_service         = "monitoring.googleapis.com/kubernetes"
  network_policy             = true
  remove_default_node_pool   = true
  initial_node_count         = 1

  node_pools = [
    {
      name         = "pool0"
      machine_type = var.machine_types[var.environment]
      #   min_count          = 3
      #   max_count          = 3
      node_count         = var.cluster_info.size
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      autoscaling        = false
      service_account    = "wetsnow-tf0@${var.project}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
