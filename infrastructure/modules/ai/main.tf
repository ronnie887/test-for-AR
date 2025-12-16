# Vertex AI Module
# Note: Vertex AI Workbench requires the newer "workbench.googleapis.com" API
# For a simple example, we'll show how to enable the API and create a dataset

# Vertex AI Dataset Example
resource "google_vertex_ai_dataset" "dataset" {
  display_name        = "example-dataset"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/image_1.0.0.yaml"
  region              = var.region
  project             = var.project_id
}

# For Vertex AI Workbench (Managed Notebooks), use:
# resource "google_workbench_instance" "instance" {
#   name     = "workbench-instance"
#   location = "${var.region}-a"
#   project  = var.project_id
#   
#   gce_setup {
#     machine_type = "e2-standard-4"
#   }
# }
