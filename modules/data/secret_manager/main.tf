resource "google_secret_manager_secret" "app_secret" {
  secret_id = var.secret_id
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version_data" {
  secret      = google_secret_manager_secret.app_secret.id
  secret_data = var.secret_data
}