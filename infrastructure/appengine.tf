# App Engine Application
# Required for Cloud Scheduler to work
resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
  
  depends_on = [
    google_project_service.appengine
  ]
}
