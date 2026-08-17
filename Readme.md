# AWS EKS Infrastructure

Terraform infrastructure for the transaction-exchange platform.

## Current scope

The implemented targets are:

- `bootstrap/`: durable Terraform state and deployment roles
- `environments/dev/vpc/`: two-AZ lab network using `modules/vpc/`
- `environments/dev/security/`: shared KMS keys and network security groups
- `environments/dev/eks-cluster/`: EKS control plane and managed node group
- `environments/dev/eks-addons/`: managed networking, DNS, proxy, identity, and storage add-ons

```text
bootstrap
  -> environments/dev/vpc
  -> environments/dev/security
  -> environments/dev/iam
  -> environments/dev/eks-cluster
  -> environments/dev/eks-addons
```

See [bootstrap/README.md](bootstrap/README.md) for the initial deployment and
state-migration procedure. See
[environments/dev/vpc/README.md](environments/dev/vpc/README.md) for the lab
network topology and initialization procedure.

## Design rules

- Every deployable target owns a separate Terraform state file.
- Reusable implementation belongs in `modules/`; environment targets remain thin.
- CI plans and applies through separate IAM roles.
- Production roles should use organization-managed permission boundaries.
- Secrets, state files and generated backend configuration are never committed.
