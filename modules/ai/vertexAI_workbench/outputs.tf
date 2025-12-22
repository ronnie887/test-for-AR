output "instance_id" {
  description = "The ID of the workbench instance"
  value       = google_workbench_instance.instance.id
}

output "proxy_uri" {
  description = "The proxy URI to access the JupyterLab interface"
  value       = google_workbench_instance.instance.proxy_uri
}