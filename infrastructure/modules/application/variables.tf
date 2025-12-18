variable "project_id" {
  description = "The ID of the project where this module will provision resources"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket for data ingestion"
  type        = string
  default     = "" # Optional default to avoid breaking existing calls immediately
}
