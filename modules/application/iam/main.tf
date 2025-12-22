resource "google_service_account" "app_runtime_sa" {
  project      = var.project_id
  account_id   = "app-runtime-sa"
  display_name = "Service Account for Cloud Run Runtime"
}

resource "google_service_account_iam_member" "github_actions" {
  service_account_id = google_service_account.app_runtime_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:github-actions-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_service_account" "secrets_reader_sa" {
  project      = var.project_id
  account_id   = "secrets-reader-sa"
  display_name = "Service Account for Reading Secrets"
}

# Grant GitHub Actions SA permission to act as the secrets SA
resource "google_service_account_iam_member" "github_actions_act_as_secrets" {
  service_account_id = google_service_account.secrets_reader_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:github-actions-sa@${var.project_id}.iam.gserviceaccount.com"
}