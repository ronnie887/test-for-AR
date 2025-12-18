output "app_bucket_name" {
  value = google_storage_bucket.app_bucket.name
}

output "app_secret_id" {
  value = google_secret_manager_secret.app_secret.secret_id
}
