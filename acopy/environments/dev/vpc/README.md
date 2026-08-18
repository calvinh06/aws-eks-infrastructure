# Development VPC

Lab VPC for the transaction-exchange platform.

## Topology

- VPC CIDR: `10.1.0.0/16`
- Availability Zones: `us-east-2a`, `us-east-2b`
- Two public ingress subnets
- Two private EKS subnets
- Two isolated private data subnets
- One shared NAT gateway in `us-east-2a`
- One S3 gateway endpoint

The single NAT gateway minimizes lab cost and is intentionally not highly
available. Production should set `nat_gateway_mode = "per_az"`.

## Initialize

Copy the local configuration files, replace the KMS key placeholder, and run:

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform fmt -check -recursive
terraform validate
terraform plan
```
