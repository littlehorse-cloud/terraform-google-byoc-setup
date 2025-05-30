variable "project_id" {
  description = "The ID of the project."
  type        = string
}

variable "repository_name" {
  description = "The name of the GitHub repository to be used for the Workload Identity Pool."
  type        = string

}

variable "organization_name" {
  description = "The name of the GitHub organization to be used for the Workload Identity Pool."
  type        = string
}

variable "bucket_terraform_state" {
  description = "The name of the GCS bucket to store Terraform state."
  default     = ""
  type        = string
}

variable "bucket_terraform_state_location" {
  description = "The location of the GCS bucket to store Terraform state."
  type        = string
  default     = "US"

}