# Development EKS cluster

Two-AZ EKS 1.35 lab cluster with a two-node `t3.medium` managed node group.
The public Kubernetes API is restricted to the CIDRs configured in
`terraform.tfvars`; private API access remains enabled.

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform validate
terraform plan -out eks-cluster.tfplan
```
