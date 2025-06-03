# Littlehorse GCP BYOC Setup

## How to use

```hcl
module "setup_byoc" {
 source  = "littlehorse-cloud/byoc-setup/google"
 version = "$MODULE_VERSION"

 project_id = "$PROJECT_ID"
 repository_name = "$REPOSITORY_NAME"
 organization_name = "$ORGANIZATION_NAME"
 bucket_terraform_state_location = "$BUCKET_TERRAFORM_STATE_LOCATION"
}
```

### Replace:

`$MODULE_VERSION` with the latest version of this module.
`$PROJECT_ID` with the target project id.
`$REPOSITORY_NAME` with the github repository hosting the byoc configuration.
`$ORGANIZATION_NAME` with the github organization or repository owner.
`$BUCKET_TERRAFORM_STATE_LOCATION` with the region code (`ASIA`, `EU`, `US`).

This module will create the service account that will be assumed in the deploy 
pipeline, along with the required roles and permissions. 

It also setups a workload identity federation to allow connections from the 
configuration repository and configures the bucket for terraform state.


## Generate script to install via cloud console shell

Run the script

```sh
./scripts/create-module-runner.sh <REPOSITORY_NAME> <ORGANIZATION_NAME> <BUCKET_TERRAFORM_STATE_LOCATION>
```

It will output `tf-byoc-module/run.sh` that can be uploaded to the cloud shell.

Once the process ends, share the output with the sales representative.
