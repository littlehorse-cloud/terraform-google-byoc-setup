#!/bin/bash
set -e

if [ "$#" -ne 3 ]; then
 echo "Use: $0 <REPOSITORY_NAME> <ORGANIZATION_NAME> <BUCKET_TERRAFORM_STATE_LOCATION>"
 exit 1
fi

REPOSITORY_NAME="$1"
ORGANIZATION_NAME="$2"
BUCKET_TERRAFORM_STATE_LOCATION="$3"
MODULE_VERSION="$(git describe --tags --abbrev=0| sed 's/^v//')"

WORKDIR="tf-byoc-module"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat > run.sh <<EOF
#!/bin/bash

cat > main.tf <<'INNER_EOF'
module "setup_byoc" {
 source  = "littlehorse-cloud/byoc-setup/google"
 version = "$MODULE_VERSION"

 project_id = var.project_id
 repository_name = "$REPOSITORY_NAME"
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
INNER_EOF

export TF_VAR_project_id=\$(gcloud config get-value project 2>/dev/null)

gcloud services enable iam.googleapis.com cloudresourcemanager.googleapis.com

terraform init
terraform apply -auto-approve

echo "Setup complete."
EOF

chmod +x run.sh

echo "Setup creation complete."
