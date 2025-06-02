locals {
  services = toset([
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com"
  ])

  bucket_terraform_state = var.bucket_terraform_state != "" ? var.bucket_terraform_state : "${var.project_id}-lh-byoc-terraform-state"
}
