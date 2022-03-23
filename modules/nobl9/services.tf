resource "nobl9_service" "web_static" {
  name         = "web-static"
  project      = nobl9_project.wetsnow.name
  display_name = "web-static"
  description  = "web service"
}