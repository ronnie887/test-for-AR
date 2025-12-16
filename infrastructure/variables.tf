variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The default GCP region"
  type        = string
  default     = "us-central1"
}

variable "domain" {
  description = "Base domain for the application (e.g., example.com). Leave empty if not using custom domain yet."
  type        = string
  default     = "example.com"
}

variable "iap_client_id" {
  description = "OAuth Client ID for Identity-Aware Proxy. Create this in GCP Console > APIs & Services > Credentials."
  type        = string
  default     = ""
}

variable "iap_client_secret" {
  description = "OAuth Client Secret for Identity-Aware Proxy"
  type        = string
  default     = ""
  sensitive   = true
}
