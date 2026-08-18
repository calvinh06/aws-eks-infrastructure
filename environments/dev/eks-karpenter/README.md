# Development Karpenter

Installs Karpenter as an independently deployable EKS component. The managed
node group remains the stable system capacity; Karpenter adds application
capacity when pods cannot be scheduled.

## Deploy

```powershell
Copy-Item backend.hcl.example backend.hcl
Copy-Item terraform.tfvars.example terraform.tfvars
notepad backend.hcl
terraform init -reconfigure "-backend-config=backend.hcl"
terraform validate
terraform plan -out eks-karpenter.tfplan
terraform apply eks-karpenter.tfplan
```

Use the bootstrap KMS key ARN in `backend.hcl`. Its state key must remain:

```hcl
key = "transaction-exchange/dev/eks-karpenter/terraform.tfstate"
```

## Verify

```powershell
kubectl get deployment karpenter -n kube-system
kubectl get ec2nodeclass
kubectl get nodepool
kubectl logs -n kube-system deployment/karpenter --tail=100
```

## Exercise node provisioning

The following disposable workload requests more capacity than the managed node
group normally has available:

```powershell
kubectl create deployment inflate --image=public.ecr.aws/eks-distro/kubernetes/pause:3.10
kubectl set resources deployment inflate --requests=cpu=1,memory=256Mi
kubectl scale deployment inflate --replicas=5
kubectl get pods -w
kubectl get nodes -L karpenter.sh/nodepool
```

Remove the test immediately afterward:

```powershell
kubectl delete deployment inflate
```

Karpenter consolidation will remove unused dynamic nodes after the configured
delay. The NodePool is limited to 20 CPUs and on-demand instances to constrain
lab cost and behavior.
