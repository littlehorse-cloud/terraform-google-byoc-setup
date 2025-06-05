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


## Install via cloud console shell

The script only needs the repository name as a parameter, the bucket terraform state location is optional.

Run the script

```sh

curl -sSL https://raw.githubusercontent.com/littlehorse-cloud/terraform-google-byoc-setup/main/scripts/setup.sh | bash -s <REPOSITORY_NAME>

```

**Note: the repository name assumes the prefix `gcp-byoc-<REPOSITORY_NAME>`**

Once the process ends, share the output with the sales representative.


## Releases

The releases of this module are automated with `git-cliff`.
