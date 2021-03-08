
project = "snowcloud-01"
region = "us-central1"
zones = ["us-central1-c"]

environment = "dev"

machine_types = {
  dev  = "e2-medium"
  test = "e2-medium"
  prod = "e2-medium"
}

cluster_info = ({
  name = "cluster0"
  size = 6
  vpc_name = "vpc0"
})

