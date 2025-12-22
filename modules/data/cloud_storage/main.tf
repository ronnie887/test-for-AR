resource "google_storage_bucket" "app_bucket" {
  name     = var.bucket_name
  location = var.region
  project  = var.project_id
  
  uniform_bucket_level_access = true
  force_destroy               = true
}