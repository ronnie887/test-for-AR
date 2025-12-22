output "load_balancer_ip" {
  description = "The public global IP address of the load balancer"
  value       = google_compute_global_address.lb_ip.address
}