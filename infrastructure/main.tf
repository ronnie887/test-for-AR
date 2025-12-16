# Infrastructure Main Configuration

# 1. Networking Module - Load Balancer
# Subdomain-based routing for web app and dashboard
module "networking" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
  
  # Pass service names from application module
  web_app_service_name  = module.application.web_app_name
  dashboard_service_name = module.application.dashboard_name
  
  domain = var.domain # e.g., "example.com"
  
  # IAP Configuration (Authentication)
  iap_client_id     = var.iap_client_id
  iap_client_secret = var.iap_client_secret
  
  depends_on = [module.application]
}

# 2. Data Module
# BigQuery, Storage, and Secrets for data pipeline
module "data" {
  source     = "./modules/data"
  project_id = var.project_id
  region     = var.region
}

# 3. Application Module
# The compute resources (Cloud Run)
module "application" {
  source     = "./modules/application"
  project_id = var.project_id
  region     = var.region
  
  depends_on = [module.data] # Wait for DB/Secrets
}

# 4. AI Module
# Vertex AI resources
module "ai" {
  source     = "./modules/ai"
  project_id = var.project_id
  region     = var.region
}
