variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "github_repos" {
  description = "List of GitHub repositories in 'org/repo' format"
  type        = list(string)
}

# 1. Enable necessary APIs (optional, but recommended)
resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "crm" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}

# 2. Create the Service Account (or use an existing one)
resource "google_service_account" "github_actions_sa" {
  project      = var.project_id
  account_id   = "github-actions-sa"
  display_name = "Service Account for GitHub Actions"
}

# 3. Create the Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool-v3"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions"
  disabled                  = false
}

# 4. Create the Workload Identity Provider
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"

  # 1. Map the claims
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  # 2. Add this CONDITION using 'assertion.repository' (NOT attribute.repository)
  attribute_condition = "assertion.repository in ${jsonencode(var.github_repos)}"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# 5. Allow the GitHub Repo to impersonate the Service Account
# We need the Project Number (not ID) for the principalSet string
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_service_account_iam_member" "workload_identity_user" {
  for_each = toset(var.github_repos)

  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"

  # This restricts access specifically to YOUR repository
  member = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/${each.value}"
}

# 6. Grant Editor Role to the Service Account
# This is required for the Service Account to provision resources
resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"
}

# CHANGE THIS: Grant Owner role instead of Editor
# This is strictly required for the FIRST-TIME creation of the App Engine application.
resource "google_project_iam_member" "sa_owner" {
  project = var.project_id
  role    = "roles/owner"  # Changed from roles/editor
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# 6. Grant Roles to the Service Account
# Roles/Editor for general access
resource "google_project_iam_member" "sa_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# Explicit Storage Admin (fixes "bucket doesn't exist" errors sometimes)
resource "google_project_iam_member" "sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# App Engine Admin (required for creating App Engine applications)
resource "google_project_iam_member" "sa_appengine_admin" {
  project = var.project_id
  role    = "roles/appengine.appAdmin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# 7. Terraform State Bucket
# Stores the state file remotely so GitHub Actions doesn't "forget" resources
resource "google_storage_bucket" "tf_state" {
  name          = "${var.project_id}-tfstate"
  location      = "US" # Multi-region for high availability
  project       = var.project_id
  force_destroy = true # Allow destroying bucket even if it has state files (for cleanup)
  
  versioning {
    enabled = true
  }
  
  uniform_bucket_level_access = true
}

# Enable App Engine Admin API (Required for google_app_engine_application)
resource "google_project_service" "appengine" {
  project = var.project_id
  service = "appengine.googleapis.com"
  
  # Recommended: Prevent disabling the API on destroy to avoid accidental data loss
  disable_on_destroy = false 
}

# Enable Cloud Scheduler API (Required for google_cloud_scheduler_job)
resource "google_project_service" "cloudscheduler" {
  project = var.project_id
  service = "cloudscheduler.googleapis.com"
  
  disable_on_destroy = false
}

# --- OUTPUTS ---
# Use these values in your GitHub Actions YAML
output "workload_identity_provider" {
  value = "projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id}"
}

output "service_account_email" {
  value = google_service_account.github_actions_sa.email
}