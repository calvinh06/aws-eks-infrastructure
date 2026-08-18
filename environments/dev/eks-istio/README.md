# Development EKS Istio stack

Apply after `eks-addons` and before application workloads.

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform plan "-out=eks-istio.tfplan"
terraform show "-no-color" eks-istio.tfplan | Out-File eks-istio-plan.txt -Encoding utf8
terraform apply eks-istio.tfplan
```

Validate with `kubectl get pods -n istio-system`, `kubectl get pods -n istio-ingress`, and `helm list` in both namespaces.
