variable "project_id" { type = string }
variable "region" { type = string }
variable "domain" { type = string }

# Service Names (to link NEGs)
variable "web_app_service_name" { type = string }
variable "dashboard_service_name" { type = string }

# IAP Configuration (Optional)
variable "iap_client_id" {
  description = "OAuth2 Client ID for Identity-Aware Proxy"
  type        = string
  default     = ""
}

variable "iap_client_secret" {
  description = "OAuth2 Client Secret for Identity-Aware Proxy"
  type        = string
  default     = ""
  sensitive   = true
}