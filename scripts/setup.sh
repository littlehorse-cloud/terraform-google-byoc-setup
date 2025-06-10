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
mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat > main.tf <<EOF
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

if ! command -v gcloud &> /dev/null
then
    echo "gcloud is not installed. Please install it first."
    exit 1
fi

export TF_VAR_project_id=$(gcloud config get-value project 2>/dev/null)

if [ -z "$TF_VAR_project_id" ]; then
  
  echo "Fetching list of GCP projects..."
  mapfile -t PROJECTS < <(gcloud projects list --format="value(projectId)")

  if [ ${#PROJECTS[@]} -eq 0 ]; then
      echo "No projects found in your GCP account."
      exit 1
  fi

  echo "Available projects:"
  for i in "${!PROJECTS[@]}"; do
      echo "$((i+1)). ${PROJECTS[$i]}"
  done


  while true; do
    read -p "Enter the number of the project you want to use: " SELECTION

    if [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ "$SELECTION" -ge 1 ] && [ "$SELECTION" -le "${#PROJECTS[@]}" ]; then
        SELECTED_PROJECT="${PROJECTS[$((SELECTION-1))]}"
        
        read -p "Are you sure you want to use $SELECTED_PROJECT? (y/n): " CONFIRMATION
        case "$CONFIRMATION" in
            [Yy]* ) 
                echo "Confirmed. Using project: $SELECTED_PROJECT"
                break
                ;;
            [Nn]* )
                echo "Selection canceled. Please choose again."
                ;;
            * )
                echo "Please answer y (yes) or n (no)."
                ;;
        esac
    else
        echo "Invalid selection. Please try again."
    fi
  done

  gcloud config set project "$SELECTED_PROJECT"

fi

gcloud services enable iam.googleapis.com cloudresourcemanager.googleapis.com

terraform init
terraform apply -auto-approve

echo "Setup complete."
