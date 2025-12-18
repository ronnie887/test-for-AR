# 1. Artifact Registry (Docker)
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "app-docker-repo"
  description   = "Docker repository for application images"
  format        = "DOCKER"
  project       = var.project_id
}

# --- SERVICE ACCOUNT FOR RUNTIME ---
resource "google_service_account" "app_runtime_sa" {
  project      = var.project_id
  account_id   = "app-runtime-sa"
  display_name = "Service Account for Cloud Run Runtime"
}

# Grant GitHub Actions SA permission to act as the runtime SA
resource "google_service_account_iam_member" "github_actions_act_as_runtime" {
  service_account_id = google_service_account.app_runtime_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:github-actions-sa@${var.project_id}.iam.gserviceaccount.com"
}

# 2. Cloud Run Service - Web Application
resource "google_cloud_run_v2_service" "web_app" {
  name     = "web-app"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

  deletion_protection = false # Allow Terraform to destroy this service

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder image
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
      ports {
        container_port = 8080
      }
    }
    service_account = google_service_account.app_runtime_sa.email
  }
}

# 3. Cloud Run Service - ML Dashboard
resource "google_cloud_run_v2_service" "dashboard" {
  name     = "ml-dashboard"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

  deletion_protection = false # Allow Terraform to destroy this service

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder image
      resources {
        limits = {
          cpu    = "2000m"
          memory = "1Gi"
        }
      }
      ports {
        container_port = 8080
      }
      
      # Dashboard will need BQ access
      env {
        name  = "GCP_PROJECT"
        value = var.project_id
      }
    }
    service_account = google_service_account.app_runtime_sa.email
  }
}

# 4. Cloud Run Job (Batch Data Ingestion)
# Grant Cloud Run service account access to secrets
data "google_project" "current" {
  project_id = var.project_id
}

resource "google_secret_manager_secret_iam_member" "census_api_access" {
  project   = var.project_id
  secret_id = "census-api-key"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.app_runtime_sa.email}"
}

# 4. Cloud Run Job (Batch Data Ingestion)
resource "google_cloud_run_v2_job" "data_ingestion" {
  name     = "data-ingestion-job"
  location = var.region
  project  = var.project_id
  
  deletion_protection = false

  template {
    template {
      containers {
        # Initial placeholder image. Real image is deployed by us-census-job CI/CD.
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        
        # Override the command (optional, but CMD in Dockerfile works)
        # command = ["python", "uscensusapi2020andabove.py"]
        
        env {
          name  = "GCP_PROJECT"
          value = var.project_id
        }
        
        env {
          name  = "GCS_BUCKET_NAME"
          value = var.bucket_name
        }
        
        # Census API Key from Secret Manager
        env {
          name = "UscensusAPI"
          value_source {
            secret_key_ref {
              secret  = "census-api-key"
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
      service_account = google_service_account.app_runtime_sa.email
    }
  }
}

# 5. Cloud Scheduler (Trigger every 10 minutes)
# NOTE: Terraform has issues creating Cloud Scheduler reliably.
# WORKAROUND: Add the scheduler manually via GCP Console after deployment.
# Instructions in walkthrough.md
#
# resource "google_cloud_scheduler_job" "job_trigger" {
#   name             = "trigger-data-ingestion"
#   description      = "Triggers the data ingestion Cloud Run Job every 10 minutes"
#   schedule         = "*/10 * * * *"
#   time_zone        = "Etc/UTC"
#   attempt_deadline = "320s"
#   region           = var.region
#   project          = var.project_id
#
#   http_target {
#     http_method = "POST"
#     uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.data_ingestion.name}:run"
#
#     oauth_token {
#       service_account_email = "${var.project_id}-compute@developer.gserviceaccount.com"
#     }
#   }
#   
#   depends_on = [google_cloud_run_v2_job.data_ingestion]
# }
