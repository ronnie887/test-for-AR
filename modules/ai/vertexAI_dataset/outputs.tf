output "dataset_id" {
  description = "The unique identifier of the created dataset"
  value       = google_vertex_ai_dataset.dataset.id
}

output "dataset_name" {
  description = "The resource name of the dataset"
  value       = google_vertex_ai_dataset.dataset.name
}