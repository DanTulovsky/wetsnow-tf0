terraform {
  required_version = ">= 0.14.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.7.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.0.0"
    }
  }

  # backend "remote" {
  #   # hostname     = "app.terraform.io"
  #   organization = "Wetsnow"

  #   workspaces {
  #     name = "wetsnow-tf0-gcp"
  #   }
  # }
}

data "google_client_config" "default" {}
