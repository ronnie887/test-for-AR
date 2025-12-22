output "email" {
  description = "The email of the runtime service account"
  value       = google_service_account.app_runtime_sa.email
}

output "secrets_sa_email" {
  description = "The email of the secrets reader service account"
  value       = google_service_account.secrets_reader_sa.email
}