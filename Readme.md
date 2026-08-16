# AWS EKS Infrastructure

Terraform infrastructure for the transaction-exchange platform.

## Current scope

The first implemented target is `bootstrap/`. It creates the durable Terraform
state backend and the deployment roles that later environment targets will use.

```text
bootstrap
  -> environments/dev/vpc
  -> environments/dev/security
  -> environments/dev/iam
  -> environments/dev/eks-cluster
  -> environments/dev/eks-addons
```

See [bootstrap/README.md](bootstrap/README.md) for the initial deployment and
state-migration procedure.

## Design rules

- Every deployable target owns a separate Terraform state file.
- Reusable implementation belongs in `modules/`; environment targets remain thin.
- CI plans and applies through separate IAM roles.
- Production roles should use organization-managed permission boundaries.
- Secrets, state files and generated backend configuration are never committed.
