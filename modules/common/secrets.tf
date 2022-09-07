# Define secret
resource "google_secret_manager_secret" "lightstep-access-token" {
  provider = google-beta
  project  = var.project_id

  secret_id = "lightstep-access-token"

  replication {
    automatic = true
  }
}

# Create a new version of the secret
resource "google_secret_manager_secret_version" "lightstep-access-token-0" {
  secret      = google_secret_manager_secret.lightstep-access-token.id
  secret_data = data.google_secret_manager_secret_version.lightstep-access-token.secret_data
}

# Create an ExternalSecret object which will be used to create a k8s secret
resource "kubectl_manifest" "lightstep-access-token" {
  for_each = var.namespaces

  yaml_body = templatefile("${path.module}/yaml/k8s/secret-lightstep-access-token.yaml", {
    secretName = google_secret_manager_secret.lightstep-access-token.secret_id
    namespace  = each.key
    projectID  = var.project_id
  })
}

data "google_secret_manager_secret_version" "lightstep-access-token" {
  secret = google_secret_manager_secret.lightstep-access-token.id
}

data "google_secret_manager_secret_version" "ambassador_license_key" {
  secret = "ambassador_license_key"
}
output "ambassador_license_key" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.ambassador_license_key.secret_data
}

data "google_secret_manager_secret_version" "grafana_admin_password" {
  secret = "grafana_admin_password"
}
output "grafana_admin_password" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.grafana_admin_password.secret_data
}

data "google_secret_manager_secret_version" "grafana_smtp_password" {
  secret = "grafana_smtp_password"
}
output "grafana_smtp_password" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.grafana_smtp_password.secret_data
}

data "google_secret_manager_secret_version" "grafana_google_client_id" {
  secret = "grafana_google_client_id"
}
output "grafana_google_client_id" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.grafana_google_client_id.secret_data
}

data "google_secret_manager_secret_version" "grafana_google_client_secret" {
  secret = "grafana_google_client_secret"
}
output "grafana_google_client_secret" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.grafana_google_client_secret.secret_data
}

data "google_secret_manager_secret_version" "nobl9_client_id" {
  secret = "nobl9_client_id"
}
output "nobl9_client_id" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.nobl9_client_id.secret_data
}

data "google_secret_manager_secret_version" "nobl9_client_secret" {
  secret = "nobl9_client_secret"
}
output "nobl9_client_secret" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.nobl9_client_secret.secret_data
}

data "google_secret_manager_secret_version" "nobl9_agent_client_id" {
  secret = "nobl9_agent_client_id"
}
output "nobl9_agent_client_id" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.nobl9_agent_client_id.secret_data
}

data "google_secret_manager_secret_version" "nobl9_agent_client_secret" {
  secret = "nobl9_agent_client_secret"
}
output "nobl9_agent_client_secret" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.nobl9_agent_client_secret.secret_data
}

data "google_secret_manager_secret_version" "nobl9_jira_api_token" {
  secret = "nobl9_jira_api_token"
}
output "nobl9_jira_api_token" {
  sensitive = true
  value     = data.google_secret_manager_secret_version.nobl9_jira_api_token.secret_data
}
