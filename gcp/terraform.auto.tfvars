
project = "snowcloud-01"
region  = "us-central1"
zones   = ["us-central1-c"]

environment = "dev"

# not used
machine_types = {
  dev  = "e2-medium"
  test = "e2-medium"
  prod = "e2-medium"
}

cluster_info = ({
  name       = "cluster0"
  vpc_name   = "vpc0"
  namespaces = ["ambassador", "monitoring", "observability", "security", "web"]
})

