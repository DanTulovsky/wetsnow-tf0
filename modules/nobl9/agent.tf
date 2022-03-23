resource "nobl9_agent" "lightstep0" {
  agent_type = "lightstep"
  name       = "lightstep0"
  project    = nobl9_project.wetsnow.name
  lightstep_config {
    organization = "wetsnow-550a21f7"
    project      = "wetsnow-dev-550a21f7"
  }
  source_of = [
    nobl9_service.web_static.name,
  ]
}