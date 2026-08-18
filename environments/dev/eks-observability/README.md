# Development EKS observability

Deploys kube-prometheus-stack as an independently removable component.

Initialize and plan:

    Copy-Item backend.hcl.example backend.hcl
    Copy-Item terraform.tfvars.example terraform.tfvars
    terraform init -backend-config="backend.hcl"
    terraform validate
    terraform plan -out="eks-observability.tfplan"

Do not apply until the EKS cluster and managed add-ons have been restored.

Grafana access:

    kubectl -n observability port-forward svc/kube-prometheus-stack-grafana 3000:80

