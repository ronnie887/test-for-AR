resource "google_vertex_ai_dataset" "dataset" {
  display_name        = var.display_name
  metadata_schema_uri = var.metadata_schema_uri
  region              = var.region
  project             = var.project_id
  
  labels = var.labels
}