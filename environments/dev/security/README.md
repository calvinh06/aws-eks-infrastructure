# Development security foundation

Creates the shared KMS keys and baseline security groups for the development
transaction-exchange environment. The VPC is resolved using its stable AWS
tags, so this target does not require access to the network Terraform state.

## Initialize

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform fmt -check -recursive
terraform validate
terraform plan -out security.tfplan
```

Destroying this target schedules its KMS keys for deletion after the configured
seven-day waiting period.
