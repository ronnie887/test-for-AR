variable "service_name" { type = string }
variable "region" { type = string }
variable "project_id" { type = string }
variable "image_url" { type = string }
variable "service_account_email" { type = string }
variable "cpu" { default = "1000m" }
variable "memory" { default = "512Mi" }
variable "env_vars" {
  type    = map(string)
  default = {}
}