
terraform {
  required_providers {
    helm       = {}
    kubernetes = {}
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
