data "google_iam_policy" "workload_identity_user" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.service_account}]"
    ]
  }
}

# Service account tied to the k8s 'k8s-external-secrets' account for access to Secret manager
resource "google_service_account" "k8s-external-secrets" {
  account_id   = var.service_account
  display_name = "k8s-external-secrets"
}

resource "google_service_account_iam_policy" "k8s-external-secrets-account-iam" {
  service_account_id = google_service_account.k8s-external-secrets.name
  policy_data        = data.google_iam_policy.workload_identity_user.policy_data
}

# Grant service account access to Secret Manager
resource "google_service_account_iam_binding" "k8s-external-secrets-account-iam" {
  service_account_id = google_service_account.k8s-external-secrets.name
  role               = "roles/iam.secretmanager.secretAccessor"

  members = [
    "serviceAccount:${var.service_account}@${var.project_id}.iam.gserviceaccount.com"
  ]
}