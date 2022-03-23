resource "nobl9_service" "web_static" {
  name         = "web-static"
  project      = nobl9_project.wetsnow.name
  display_name = "${nobl9_project.wetsnow.display_name} web-static"
  description  = "web service"
}