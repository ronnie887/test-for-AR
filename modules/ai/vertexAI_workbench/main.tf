# # Note: Ensure the "workbench.googleapis.com" API is enabled in your project
# resource "google_workbench_instance" "instance" {
#   name     = var.instance_name
#   location = var.location  # e.g., us-central1-a
#   project  = var.project_id
  
#   gce_setup {
#     machine_type = var.machine_type
    
#     # Optional: Add network interfaces or boot disk options here if needed
#   }
# }