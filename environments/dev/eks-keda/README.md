# Development EKS KEDA

Installs KEDA core after the EKS cluster and managed add-ons are healthy.

    Copy-Item backend.hcl.example backend.hcl
    Copy-Item terraform.tfvars.example terraform.tfvars
    terraform init "-backend-config=backend.hcl"
    terraform validate
    terraform plan "-out=eks-keda.tfplan"
    terraform apply eks-keda.tfplan

Validate with:

    kubectl get pods -n keda
    kubectl get crd | Select-String "keda.sh"
    helm list -n keda

Application repositories own ScaledObject, ScaledJob, and authentication
resources.

