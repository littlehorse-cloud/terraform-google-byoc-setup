resource "google_storage_bucket" "terraform_state" {
  name          = local.bucket_terraform_state
  project       = var.project_id
  location      = var.bucket_terraform_state_location
  force_destroy = true

  public_access_prevention = "enforced"
}
