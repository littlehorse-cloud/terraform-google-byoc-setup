output "terraform_byoc_state" {
  description = "This output provides the Terraform state bucket name for BYOC."
  value       = google_storage_bucket.terraform_state.name
}