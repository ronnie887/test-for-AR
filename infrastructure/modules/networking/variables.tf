variable "project_id" {
  description = "The ID of the project where this module will provision resources"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "web_app_service_name" {
  description = "Name of the web application Cloud Run service"
  type        = string
}

variable "dashboard_service_name" {
  description = "Name of the ML dashboard Cloud Run service"
  type        = string
}

variable "domain" {
  description = "Base domain for the application (e.g., example.com)"
  type        = string
  default     = ""
}

variable "iap_client_id" {
  description = "OAuth Client ID for Identity-Aware Proxy"
  type        = string
  default     = ""     # Optional, to allow toggle
}

variable "iap_client_secret" {
  description = "OAuth Client Secret for Identity-Aware Proxy"
  type        = string
  default     = ""
  sensitive   = true
}
