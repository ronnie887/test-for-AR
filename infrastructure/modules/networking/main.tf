# Networking Module - Load Balancer for Multi-Service Architecture
# Implements subdomain-based routing:
# - www.yourdomain.com -> Web Application
# - dashboard.yourdomain.com -> ML Dashboard

# 1. Global IP Address (What you point your domain to)
resource "google_compute_global_address" "lb_ip" {
  name    = "app-lb-ip"
  project = var.project_id
}

# 2. Serverless NEG for Web App
resource "google_compute_region_network_endpoint_group" "web_app_neg" {
  name                  = "web-app-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  
  cloud_run {
    service = var.web_app_service_name
  }
}

# 3. Serverless NEG for Dashboard
resource "google_compute_region_network_endpoint_group" "dashboard_neg" {
  name                  = "dashboard-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  
  cloud_run {
    service = var.dashboard_service_name
  }
}

# 4. Backend Service for Web App
resource "google_compute_backend_service" "web_app_backend" {
  name        = "web-app-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  project     = var.project_id

  # Enable Cloud CDN for caching static assets
  enable_cdn  = true
  
  # Optional: Customize cache policy if needed
  # cdn_policy { ... }

  backend {
    group = google_compute_region_network_endpoint_group.web_app_neg.id
  }
}

# 5. Backend Service for Dashboard
resource "google_compute_backend_service" "dashboard_backend" {
  name        = "dashboard-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  project     = var.project_id
  
  # Enable Identity-Aware Proxy (Authentication)
  iap {
    oauth2_client_id     = var.iap_client_id
    oauth2_client_secret = var.iap_client_secret
    enabled              = (var.iap_client_id != "")
  }

  backend {
    group = google_compute_region_network_endpoint_group.dashboard_neg.id
  }
}

# 6. URL Map with Host-Based Routing
resource "google_compute_url_map" "default" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.web_app_backend.id
  project         = var.project_id

  host_rule {
    hosts        = ["dashboard.${var.domain}"]
    path_matcher = "dashboard"
  }

  path_matcher {
    name            = "dashboard"
    default_service = google_compute_backend_service.dashboard_backend.id
  }
  
  # Default: all other traffic goes to web app
  # Including www.domain.com and domain.com
}

# 7. Target HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.default.id
  project = var.project_id
}

# 8. Forwarding Rule (The Front Door)
resource "google_compute_global_forwarding_rule" "http" {
  name       = "app-http-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
  project    = var.project_id
}

# ===== HTTPS CONFIGURATION (Optional - Uncomment when you have a domain) =====
# 
# # SSL Certificate (Managed by Google)
# resource "google_compute_managed_ssl_certificate" "default" {
#   name    = "app-ssl-cert"
#   project = var.project_id
#
#   managed {
#     domains = [
#       var.domain,
#       "www.${var.domain}",
#       "dashboard.${var.domain}"
#     ]
#   }
# }
#
# # Target HTTPS Proxy
# resource "google_compute_target_https_proxy" "default" {
#   name             = "app-https-proxy"
#   url_map          = google_compute_url_map.default.id
#   ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
#   project          = var.project_id
# }
#
# # HTTPS Forwarding Rule
# resource "google_compute_global_forwarding_rule" "https" {
#   name       = "app-https-forwarding-rule"
#   target     = google_compute_target_https_proxy.default.id
#   port_range = "443"
#   ip_address = google_compute_global_address.lb_ip.address
#   project    = var.project_id
# }
