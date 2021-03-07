terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    # kafka = {
    #   source = "Mongey/kafka"
    # }
  }
}

data "google_client_config" "default" {}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  #   zone    = var.zone
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

# provider "kafka" {
#   bootstrap_servers = ["kafk0.kafka:9092"]
# }
provider "kubectl" {
  # config_path = "~/.kube/config"  # don't use this...
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  apply_retry_count      = 5
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
# provider "kubernetes-alpha" {
#   server_side_planning = false
#   config_path          = "~/.kube/config"
# }
