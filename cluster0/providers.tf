# State is stored in a GCS bucket called: terraform-gcs

provider "google" {
  # export GOOGLE_CREDENTIALS=/Users/dant/github/wetsnow-tf0/cluster0/.gcloud_credentials
  project = var.project
  region  = var.region
  #   zone    = var.zone
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.cluster0.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster0.master_auth[0].cluster_ca_certificate,
    )
  }
  #  experiments {
  #    manifest = true
  #  }
}

provider "kubectl" {
  # config_path = "~/.kube/config"  # don't use this...
  load_config_file = false
  host             = "https://${data.google_container_cluster.cluster0.endpoint}"
  token            = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster0.master_auth[0].cluster_ca_certificate,
  )
  apply_retry_count = 5
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host  = "https://${data.google_container_cluster.cluster0.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster0.master_auth[0].cluster_ca_certificate,
  )
}

provider "nobl9" {
  organization  = "wetsnow-AhEoLssUoSbE"
  project       = "wetsnow"
  client_id     = module.common.nobl9_client_id
  client_secret = module.common.nobl9_client_secret
}