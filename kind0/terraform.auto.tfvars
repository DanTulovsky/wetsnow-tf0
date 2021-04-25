environment = "dev"

# not used
machine_types = {
  dev  = "e2-medium"
  test = "e2-medium"
  prod = "e2-medium"
}

cluster_info = ({
  name = "kind0"
  vpc_name = "vpc0"
  namespaces = ["ambassador", "db", "kafka", "kyverno", "monitoring", "observability", "vector", "weave", "web"]
})

