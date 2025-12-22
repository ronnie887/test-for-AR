variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "location" {
  description = "The zonal location for the workbench instance (e.g., us-central1-a)"
  type        = string
  default = "us-central1-a"
}

variable "instance_name" {
  description = "The name of the workbench instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the instance"
  type        = string
  default     = "e2-standard-4"
}