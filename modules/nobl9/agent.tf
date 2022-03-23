#resource "nobl9_agent" "lightstep" {
#  agent_type = "lightstep"
#  name       = "lightstep"
#  project    = nobl9_project.wetsnow.name
#  lightstep_config {
#    organization = "wetsnow-550a21f7"
#    project      = "wetsnow-dev-550a21f7"
#  }
#  source_of = [
#    "Metrics",
#    "Services",
#  ]
#}