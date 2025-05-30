

resource "google_iam_workload_identity_pool" "github_pool" {
  provider                  = google
  workload_identity_pool_id = "github-pool-5"
  display_name              = "GitHub Pool"
  description               = "Github Workload Identity Pool for LittleHorse BYOC"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = "assertion.repository_owner=='${var.organization_name}'"
}


resource "google_service_account_iam_member" "github_sa_binding" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/subject/repo:${var.organization_name}/${var.repository_name}:ref:refs/heads/main"
}

