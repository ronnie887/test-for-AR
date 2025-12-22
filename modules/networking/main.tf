# 1. Global IP Address
resource "google_compute_global_address" "lb_ip" {
  name    = "app-lb-ip"
  project = var.project_id
}

# 2. Serverless NEGs (Links Load Balancer to Cloud Run)
resource "google_compute_region_network_endpoint_group" "web_app_neg" {
  name                  = "web-app-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  
  cloud_run {
    service = var.web_app_service_name
  }
}

resource "google_compute_region_network_endpoint_group" "dashboard_neg" {
  name                  = "dashboard-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
 
  cloud_run {
    service = var.dashboard_service_name
  }
}

# 3. Backend Services
resource "google_compute_backend_service" "web_app_backend" {
  name        = "web-app-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  project     = var.project_id
  enable_cdn  = true

  backend {
    group = google_compute_region_network_endpoint_group.web_app_neg.id
  }
}

resource "google_compute_backend_service" "dashboard_backend" {
  name        = "dashboard-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  project     = var.project_id
  
  # Identity-Aware Proxy Configuration
  iap {
    oauth2_client_id     = var.iap_client_id
    oauth2_client_secret = var.iap_client_secret
    enabled              = (var.iap_client_id != "")
  }

  backend {
    group = google_compute_region_network_endpoint_group.dashboard_neg.id
  }
}

# 4. URL Map (Routing Rules)
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
}

# 5. HTTP Proxy & Forwarding Rule
resource "google_compute_target_http_proxy" "default" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.default.id
  project = var.project_id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "app-http-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
  project    = var.project_id
}