variable "project_id" {
  description = "The ID of the project where this module will provision resources"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1"
}
