# App Engine Application
# Required for Cloud Scheduler to work
resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = "us-central"  # App Engine uses different location IDs (no "-1" suffix)
  
  depends_on = [
    google_project_service.appengine
  ]
}
