variable "job_name" { type = string }
variable "region" { type = string }
variable "project_id" { type = string }
variable "bucket_name" { type = string }
variable "service_account_email" { type = string }
variable "secret_id" {
  description = "The Secret Manager ID for the API key"
  type        = string
  #default     = "census-api-key"
}