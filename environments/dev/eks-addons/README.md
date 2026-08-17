# Development EKS add-ons

Migrates bootstrap system components to AWS-managed add-ons and installs Pod
Identity Agent and EBS CSI with dedicated Pod Identity roles.

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform validate
terraform plan -out eks-addons.tfplan
```
