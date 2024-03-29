resource "nobl9_alert_method_email" "default" {
  name    = "default-email-method"
  project = nobl9_project.wetsnow.name
  subject = "Your SLO $slo_name needs attention!"
  body    = <<EOT
$alert_policy_name has triggered with the following conditions:
$alert_policy_conditions[]

Time: $timestamp
Severity: $severity
Project: $project_name
Service: $service_name
Organization: $organization
Labels:
- SLO: $slo_labels_text
- Service: $service_labels_text
- Alert Policy: $alert_policy_labels_text
EOT
  to = [
    "dant@wetsnow.com"
  ]
}

resource "nobl9_alert_method_jira" "jira_ticket" {
  name        = "jira-ticket"
  project     = nobl9_project.wetsnow.name
  project_key = "SELF"
  url         = "https://wetsnow0.atlassian.net/"
  username    = "dant@wetsnow.com"
  apitoken    = var.jira_api_token
}

