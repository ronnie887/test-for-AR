# Outputs for Application Module

output "web_app_name" {
  description = "Name of the web application Cloud Run service"
  value       = google_cloud_run_v2_service.web_app.name
}

output "dashboard_name" {
  description = "Name of the ML dashboard Cloud Run service"
  value       = google_cloud_run_v2_service.dashboard.name
}

output "web_app_url" {
  description = "URL of the web application"
  value       = google_cloud_run_v2_service.web_app.uri
}

output "dashboard_url" {
  description = "URL of the ML dashboard"
  value       = google_cloud_run_v2_service.dashboard.uri
}

output "artifact_registry_url" {
  description = "URL of the Artifact Registry repository"
  value       = "${google_artifact_registry_repository.docker_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}
