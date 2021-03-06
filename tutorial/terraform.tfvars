credentials_file = "/Users/dant/Downloads/snowcloud-1006f5f25962.json"

project = "snowcloud-01"
region = "us-central1"
zone = "us-central1-a"

environment = "dev"

machine_types = {
  dev  = "f1-micro"
  test = "n1-highcpu-32"
  prod = "n1-highcpu-32"
}
