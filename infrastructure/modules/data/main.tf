# 1. Cloud Storage
resource "google_storage_bucket" "app_bucket" {
  name     = "${var.project_id}-data-bucket-8871" # Must be globally unique
  location = var.region
  project  = var.project_id
  
  uniform_bucket_level_access = true
  force_destroy               = false
}

# 2. Secret Manager
resource "google_secret_manager_secret" "app_secret" {
  secret_id = "example-app-secret-8871"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version_data" {
  secret = google_secret_manager_secret.app_secret.id
  secret_data = "super-sensitive-data" # In real usage, ignore this or pass variable
}

# 3. Cloud SQL (PostgreSQL - Lowest Tier) - COMMENTED OUT
# Not needed for BigQuery-centric architecture
# Uncomment if you need:
# - Transactional workloads (CRUD operations)
# - Low-latency single-row lookups
# - Relational database features

# resource "google_sql_database_instance" "postgres" {
#   name             = "app-postgres-instance"
#   database_version = "POSTGRES_15"
#   region           = var.region
#   project          = var.project_id
#   
#   deletion_protection = false # Set to true for production
#
#   settings {
#     # "db-f1-micro" is the smallest shared-core machine type
#     tier = "db-f1-micro"
#     
#     availability_type = "ZONAL" # Single zone (cheaper)
#     disk_type         = "PD_SSD"
#     disk_size         = 10     # GB
#     
#     ip_configuration {
#       ipv4_enabled    = true 
#       # ssl_mode      = "ENCRYPTED_ONLY" 
#     }
#   }
# }

# resource "google_sql_database" "database" {
#   name     = "app-db"
#   instance = google_sql_database_instance.postgres.name
#   project  = var.project_id
# }

# resource "google_sql_user" "users" {
#   name     = "postgres-user"
#   instance = google_sql_database_instance.postgres.name
#   password = "changeme" # Should ideally be from Secret Manager
#   project  = var.project_id
# }

# 4. BigQuery (Regional)
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "app_analytics_8871"
  friendly_name               = "App Analytics"
  description                 = "Regional dataset for application analytics"
  location                    = var.region # Using the same region as the app
  project                     = var.project_id
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}
