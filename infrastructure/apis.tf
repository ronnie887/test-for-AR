# Enable Required Google Cloud APIs
# This ensures that all necessary services are enabled in the project
# before Terraform attempts to create resources that depend on them.

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",              # Load Balancers, NEGs
    "run.googleapis.com",                  # Cloud Run Services & Jobs
    "artifactregistry.googleapis.com",     # Docker Images
    "bigquery.googleapis.com",             # Data Warehouse
    "storage.googleapis.com",              # Cloud Storage
    "secretmanager.googleapis.com",        # Secrets Management
    "aiplatform.googleapis.com",           # Vertex AI
    "iap.googleapis.com",                  # Identity-Aware Proxy
    "cloudresourcemanager.googleapis.com", # Project Metadata
    "serviceusage.googleapis.com",         # Enabling other APIs
    "iam.googleapis.com"                   # Identity & Access Management
  ])

  project = var.project_id
  service = each.key

  # Prevent Terraform from disabling the API when destroying resources
  # This is safer for production environments
  disable_on_destroy = false
}
