# 1. Artifact Registry (Docker)
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "app-docker-repo"
  description   = "Docker repository for application images"
  format        = "DOCKER"
  project       = var.project_id
}

# 2. Cloud Run Service - Web Application
resource "google_cloud_run_v2_service" "web_app" {
  name     = "web-app"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

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
  }
}

# 3. Cloud Run Service - ML Dashboard
resource "google_cloud_run_v2_service" "dashboard" {
  name     = "ml-dashboard"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

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
  }
}

# 4. Cloud Run Job (Batch Data Ingestion)
# 4. Cloud Run Job (Batch Data Ingestion) - COMMENTED OUT
# Uncomment after Artifact Registry is created and image is pushed
# resource "google_cloud_run_v2_job" "data_ingestion" {
#   name     = "data-ingestion-job"
#   location = var.region
#   project  = var.project_id
# 
#   template {
#     template {
#       containers {
#         image = "us-docker.pkg.dev/cloudrun/container/job-sample:latest" # Placeholder
#         command = ["python", "ingest.py"]
#         
#         env {
#           name  = "GCP_PROJECT"
#           value = var.project_id
#         }
#       }
#     }
#   }
# }
