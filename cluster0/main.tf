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
    kafka = {
      source = "Mongey/kafka"
    }
  }
}

data "google_client_config" "default" {}
