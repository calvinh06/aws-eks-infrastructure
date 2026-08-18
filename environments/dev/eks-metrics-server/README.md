# Development Metrics Server

Installs Metrics Server as an independently deployable EKS platform component.
The EKS cluster and its worker nodes must be running before this target is
applied.

## Deploy

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init "-backend-config=backend.hcl"
terraform validate
terraform plan -out eks-metrics-server.tfplan
terraform apply eks-metrics-server.tfplan
```

## Verify

Allow roughly a minute for the first metrics samples, then run:

```powershell
kubectl get deployment metrics-server -n kube-system
kubectl get apiservice v1beta1.metrics.k8s.io
kubectl top nodes
kubectl top pods -A
```

The APIService should report `Available=True`, and both `kubectl top` commands
should return CPU and memory usage.

## Remove only Metrics Server

```powershell
terraform plan -destroy -out eks-metrics-server-destroy.tfplan
terraform apply eks-metrics-server-destroy.tfplan
```
