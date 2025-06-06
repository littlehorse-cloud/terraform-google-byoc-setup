#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Use: $0 <REPOSITORY_NAME> OPTIONAL:<BUCKET_TERRAFORM_STATE_LOCATION>"
  exit 1
fi

REPOSITORY_NAME="$1"
BUCKET_TERRAFORM_STATE_LOCATION=${2:-"US"}
ORGANIZATION_NAME="littlehorse-cloud"
MODULE_VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/littlehorse-cloud/terraform-google-byoc-setup.git | grep -v '\^{}' | tail -n1 | sed 's/.*\///; s/^v//')"

WORKDIR="tf-byoc-module"

# if workdir exists then exit with error
if [ -d "$WORKDIR" ]; then
  echo "Error: There is an existing state, if you want to preserve state then run terraform from within ./$WORKDIR folder, otherwise delete the folder and try again."
  exit 1
fi

mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat >main.tf <<EOF
module "setup_byoc" {
 source  = "littlehorse-cloud/byoc-setup/google"
 version = "$MODULE_VERSION"

 project_id = var.project_id
 repository_name = "gcp-byoc-$REPOSITORY_NAME"
 organization_name = "$ORGANIZATION_NAME"
 bucket_terraform_state_location = "$BUCKET_TERRAFORM_STATE_LOCATION"
}

variable "project_id" {
 type = string
 description = "The ID of the Google Cloud project."
}

output "byoc_setup_details" {
 value = module.setup_byoc.byoc_setup_details
 description = "Details of the BYOC setup."
}

provider "google" {
 project = var.project_id
}

EOF

export TF_VAR_project_id=$(gcloud config get-value project 2>/dev/null)

gcloud services enable iam.googleapis.com cloudresourcemanager.googleapis.com

terraform init
terraform apply -auto-approve

echo "Setup complete."
