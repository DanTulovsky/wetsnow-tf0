# provider "google" {
#   # export GOOGLE_CREDENTIALS=/Users/dant/github/wetsnow-tf0/cluster0/.gcloud_credentials
#   project = var.project
#   region  = var.region
#   #   zone    = var.zone
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/kind-config" # don't use this...
    # host                   = "https://${module.gke.endpoint}"
    # token                  = data.google_client_config.default.access_token
    # cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }

  # experiments {
  #  manifest = true
  # }
}

provider "kubectl" {
  config_path = "~/.kube/kind-config" # don't use this...
  # load_config_file       = false
  # host                   = "https://${module.gke.endpoint}"
  # token                  = data.google_client_config.default.access_token
  # cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  # apply_retry_count      = 5
}

provider "kubernetes" {
  config_path = "~/.kube/kind-config" # don't use this...
  # load_config_file       = false
  # host                   = "https://${module.gke.endpoint}"
  # token                  = data.google_client_config.default.access_token
  # cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
# provider "kubernetes-alpha" {
#   server_side_planning = false
# }
