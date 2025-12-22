variable "project_id" { type = string }
variable "region" { type = string }
variable "domain" { type = string }

variable "iap_client_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "iap_client_secret" {
  type      = string
  sensitive = true
  default   = ""
}
