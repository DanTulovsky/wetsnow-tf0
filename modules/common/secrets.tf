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

  provider = google-beta

  secret      = google_secret_manager_secret.lightstep-access-token.id
  secret_data = var.lightstep_access_token
}

# Create an ExternalSecret object which will be used to create a k8s secret
resource "kubectl_manifest" "lightstep-access-token" {
  #  for_each = var.namespaces

  yaml_body = templatefile("${path.module}/yaml/k8s/secret-lightstep-access-token.yaml", {
    secretName = google_secret_manager_secret.lightstep-access-token.secret_id
    #    namespace  = each.key
    namespace = "web"
    projectID = var.project_id
  })
}
