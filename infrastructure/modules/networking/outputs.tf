# Outputs for Networking Module

output "load_balancer_ip" {
  description = "Static IP address of the Load Balancer (point your DNS here)"
  value       = google_compute_global_address.lb_ip.address
}

output "load_balancer_ip_name" {
  description = "Name of the reserved IP address"
  value       = google_compute_global_address.lb_ip.name
}
