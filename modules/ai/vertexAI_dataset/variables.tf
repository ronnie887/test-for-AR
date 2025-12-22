variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for the dataset"
  type        = string
  default = "us-central1"
}

variable "display_name" {
  description = "The display name of the dataset"
  type        = string
}

variable "metadata_schema_uri" {
  description = "Points to a YAML file detailing the metadata of the dataset."
  type        = string
  default     = "gs://google-cloud-aiplatform/schema/dataset/metadata/image_1.0.0.yaml"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the resource"
  type        = map(string)
  default     = {}
}