# Terraform Bootstrap

This target creates the resources required before any environment Terraform can
use remote state:

- An S3 state bucket with versioning, public-access blocking and KMS encryption
- Native S3 state locking through Terraform's `use_lockfile` backend option
- A read-oriented Terraform plan role
- A separately authorized Terraform apply role
- A narrowly scoped policy granting both roles access to the state backend

## Security posture

The apply role intentionally has no infrastructure-management policy by
default. Supply organization-reviewed policy ARNs through
`apply_managed_policy_arns`. Do not attach `AdministratorAccess` in production
unless the organization has explicitly accepted that risk and applies an
appropriate permission boundary.

The KMS key and state bucket use `prevent_destroy`. Their removal requires a
deliberate code change and a separate data-retention decision.

## First deployment

Requirements:

- Terraform 1.10 or newer
- AWS credentials for an authorized bootstrap administrator
- A globally unique S3 bucket name

Create the local configuration:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Replace all placeholder values, then run:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out bootstrap.tfplan
terraform apply bootstrap.tfplan
```

The initial bootstrap state is local. Protect that file until migration is
complete.

## Migrate bootstrap state to S3

1. Copy `backend.tf.example` to `backend.tf`.
2. Copy `backend.hcl.example` to `backend.hcl`.
3. Populate `backend.hcl` using the Terraform outputs.
4. Migrate the state:

```bash
terraform init -migrate-state -backend-config=backend.hcl
```

After confirming the remote state exists and a new plan reports no unintended
changes, securely remove the old local state copies. Never commit
`terraform.tfvars`, `backend.hcl`, state files or plan files.

## Later target configuration

Every environment target uses the same bucket and KMS key with a unique key:

```text
transaction-exchange/dev/vpc/terraform.tfstate
transaction-exchange/dev/security/terraform.tfstate
transaction-exchange/dev/iam/terraform.tfstate
transaction-exchange/dev/eks-cluster/terraform.tfstate
transaction-exchange/dev/eks-addons/terraform.tfstate
```

CI uses the plan role for speculative plans and the apply role only after the
environment's required approval.

