resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.repo_id
  description   = "Docker repository for application images"
  format        = "DOCKER"
  project       = var.project_id
}