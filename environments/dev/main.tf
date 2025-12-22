# 0. Artifact Registry (For Docker Images)
module "artifact_registry" {
  source     = "../../modules/application/artifact_registry"
  project_id = var.project_id
  region     = var.region
  repo_id    = "app-docker-repo"
}

# 1. Identity Module (Service Accounts)
module "identity" {
  source     = "../../modules/application/iam"
  project_id = var.project_id
}

# 2. Data Module (Storage)
module "data_buckets" {
  source      = "../../modules/data/cloud_storage"
  project_id  = var.project_id
  region      = var.region
  bucket_name = "${var.project_id}-data-bucket-${random_id.bucket_suffix.hex}"
}

# Need a suffix for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 3. Application Module (Web App Service)
module "web_app" {
  source                = "../../modules/application/cloudrun_service"
  service_name          = "dev-web-app"
  region                = var.region
  project_id            = var.project_id
  image_url             = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder
  service_account_email = module.identity.email
  
  cpu    = "1000m"
  memory = "512Mi"
}

# 4. Application Module (Dashboard Service)
module "dashboard" {
  source                = "../../modules/application/cloudrun_service"
  service_name          = "dev-ml-dashboard"
  region                = var.region
  project_id            = var.project_id
  image_url             = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder
  service_account_email = module.identity.email
  
  # Custom sizing for dashboard
  cpu    = "2000m"
  memory = "1Gi"
  
  env_vars = {
    "GCP_PROJECT" = var.project_id
    "ENV_TYPE"    = "dev"
  }
}

# 5. Cloud Run Job (Census Data Ingestion)
module "census_job" {
  source                = "../../modules/application/cloudrun_job"
  job_name              = "dev-census-ingestion"
  region                = var.region
  project_id            = var.project_id
  bucket_name           = module.data_buckets.bucket_name
  service_account_email = module.identity.secrets_sa_email # Use specialized SA
  secret_id             = "census-api-key"
}

# Grant Secrets SA access to the bucket (for writing data)
resource "google_storage_bucket_iam_member" "secrets_sa_storage_admin" {
  bucket = module.data_buckets.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.identity.secrets_sa_email}"
}

# 6. Networking Module (Load Balancer & IAP)
module "networking" {
  source     = "../../modules/networking"
  project_id = var.project_id
  region     = var.region
  domain     = var.domain
  
  web_app_service_name   = module.web_app.service_name
  dashboard_service_name = module.dashboard.service_name
  
  iap_client_id     = var.iap_client_id
  iap_client_secret = var.iap_client_secret
}
