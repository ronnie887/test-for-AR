# Grant IAM access to the secret
resource "google_secret_manager_secret_iam_member" "api_access" {
  project   = var.project_id
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account_email}"
}

resource "google_cloud_run_v2_job" "ingestion_job" {
  name     = var.job_name
  location = var.region
  project  = var.project_id
  deletion_protection = false

  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        
        env {
          name  = "GCP_PROJECT"
          value = var.project_id
        }
        env {
          name  = "GCS_BUCKET_NAME"
          value = var.bucket_name
        }
        env {
          name = "UscensusAPI"
          value_source {
            secret_key_ref {
              secret  = var.secret_id
              version = "latest"
            }
          }
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
      }
      service_account = var.service_account_email
    }
  }
}