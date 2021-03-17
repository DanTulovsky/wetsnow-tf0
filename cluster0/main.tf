terraform {
  required_version = ">= 0.14.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.58.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  #backend "remote" {
  #  # hostname     = "app.terraform.io"
  #  organization = "Wetsnow"

  #  workspaces {
  #    name = "wetsnow-tf0"
  #  }
  #}
}

data "google_container_cluster" "cluster0" {
  name     = var.cluster_info.name
  location = var.zones[0]
}

data "google_client_config" "default" {}
