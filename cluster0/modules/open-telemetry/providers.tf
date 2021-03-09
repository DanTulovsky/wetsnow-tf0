terraform {
  required_providers {
    kubernetes = {}
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
