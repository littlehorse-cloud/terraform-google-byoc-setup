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

Conventional commits are used to decide which version will be released

- `fix:` -> increments PATCH.
- `feat:` -> increments MINOR.
- `<scope>!:` (breaking changes) -> increments MAJOR.
- `chore|ci|refactor|style|test|doc"` -> Ignored, won't create a release.

Look at [`cliff.toml`](./cliff.toml) to see a more up to date configuration.

## How to contribute

### Requirements

- pre-commit `pip install pre-commit`
- hcledit `brew install minamijoyo/hcledit/hcledit`
- tflint `brew install tflint`

Make sure to install pre-commit

```sh
pre-commit install
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.14.0, < 7 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1, < 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.14.0, < 7 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1, < 4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.github_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.github_provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_custom_role.custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.compute_viewer_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.project_services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.github_sa_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_id.identity_pool_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_terraform_state"></a> [bucket\_terraform\_state](#input\_bucket\_terraform\_state) | The name of the GCS bucket to store Terraform state. | `string` | `""` | no |
| <a name="input_bucket_terraform_state_location"></a> [bucket\_terraform\_state\_location](#input\_bucket\_terraform\_state\_location) | The location of the GCS bucket to store Terraform state. | `string` | `"US"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the GitHub organization to be used for the Workload Identity Pool. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project. | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the GitHub repository to be used for the Workload Identity Pool. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_byoc_setup_details"></a> [byoc\_setup\_details](#output\_byoc\_setup\_details) | BYOC setup details |
<!-- END_TF_DOCS -->
