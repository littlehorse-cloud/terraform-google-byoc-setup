#!/bin/bash

set -e

if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <PROJECT_ID> <REPOSITORY_NAME> <ORGANIZATION_NAME> <BUCKET_LH_BYOC_TERRAFORM_STATE>"
  exit 1
fi

PROJECT_ID="$1"
REPOSITORY_NAME="$2"
ORGANIZATION_NAME="$3"
BUCKET_LH_BYOC_TERRAFORM_STATE="$4"

WORKDIR="tf-byoc-module"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat > main.tf <<EOF
module "setup-byouc" {
  source  = "terraform-gcp-modules/byoc/gcp/setup"
  version = "1.0.0"

  project_id = "$PROJECT_ID"
  repository_name = "$REPOSITORY_NAME"
  organization_name = "$ORGANIZATION_NAME"
  bucket_lh_byoc_terraform_state = "$BUCKET_LH_BYOC_TERRAFORM_STATE"

}
EOF

cat > run.sh <<EOF
#!/bin/bash

terraform init

terraform apply -auto-approve

cho "Setup complete."
EOF

chmod +x run.sh

echo "Setup creation complete."