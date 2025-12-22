resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = "App Analytics"
  description                 = "Regional dataset for application analytics"
  location                    = var.location
  project                     = var.project_id
  default_table_expiration_ms = 3600000

  labels = {
    env = "managed-by-terraform"
  }
}