terraform {
  required_providers {
    planetscale = {
      source  = "s1ntaxe770r/planetscale"
      version = "0.1.2"
    }
  }
}

provider "planetscale" {
  access_token = var.planetscale_access_token
}
