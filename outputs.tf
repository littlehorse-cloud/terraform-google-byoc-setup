output "byoc_setup_details" {
  description = "BYOC setup details"
  value = {
    project_id        = var.project_id
    bucket_name       = google_storage_bucket.terraform_state.name
    workload_provider = google_iam_workload_identity_pool_provider.github_provider.name
  }
}
