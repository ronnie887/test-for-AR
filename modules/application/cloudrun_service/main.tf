resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    containers {
      image = var.image_url
      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }
      ports { container_port = 8080 }
      
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
    service_account = var.service_account_email
  }
}