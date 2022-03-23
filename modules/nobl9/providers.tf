terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {}
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    nobl9 = {
      source  = "nobl9/nobl9"
      version = ">= 0.1.4"
    }
  }
}