#!/bin/bash
set -e

if [ "$#" -ne 4 ]; then
 echo "Uso: $0 <REPOSITORY_NAME> <ORGANIZATION_NAME> <BUCKET_TERRAFORM_STATE> <BUCKET_TERRAFORM_STATE_LOCATION>"
 exit 1
fi

REPOSITORY_NAME="$1"
ORGANIZATION_NAME="$2"
BUCKET_TERRAFORM_STATE="$3"
BUCKET_TERRAFORM_STATE_LOCATION="$4"

WORKDIR="tf-byoc-module"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat > main.tf <<EOF
module "setup-byouc" {
 source  = "littlehorse-cloud/byoc-setup/google"
 version = "0.0.1"

 project_id = var.project_id
 repository_name = "$REPOSITORY_NAME"
 organization_name = "$ORGANIZATION_NAME"
 bucket_terraform_state = "$BUCKET_TERRAFORM_STATE"
 bucket_terraform_state_location = "$BUCKET_TERRAFORM_STATE_LOCATION"
}

variable "project_id" {
 type = string
 description = "The ID of the Google Cloud project."
}
EOF

cat > run.sh <<EOF
#!/bin/bash

export TF_VAR_project_id=\$(gcloud config get-value project 2>/dev/null)

gcloud services enable iam.googleapis.com cloudresourcemanager.googleapis.com

terraform init
terraform apply -auto-approve

echo "Setup complete."
EOF

chmod +x run.sh

echo "Setup creation complete."