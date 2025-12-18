# Enable Required Google Cloud APIs
# This ensures that all necessary services are enabled in the project
# before Terraform attempts to create resources# Enable required GCP APIs
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "run" {
  project = var.project_id
  service = "run.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "secretmanager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "aiplatform" {
  project = var.project_id
  service = "aiplatform.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "iap" {
  project = var.project_id
  service = "iap.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "serviceusage" {
  project = var.project_id
  service = "serviceusage.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "cloudscheduler" {
  project = var.project_id
  service = "cloudscheduler.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}

resource "google_project_service" "appengine" {
  project = var.project_id
  service = "appengine.googleapis.com"
  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}
