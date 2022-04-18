project = "snowcloud-01"
region  = "us-central1"
zones   = ["us-central1-c"]

environment = "dev"

cluster_info = ({
  name       = "cluster0"
  vpc_name   = "vpc0"
  namespaces = ["ambassador", "argocd", "kubecost", "monitoring", "observability", "security", "web"]
})

