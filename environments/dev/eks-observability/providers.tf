provider "aws" {
  region = var.aws_region
  dynamic "assume_role" {
    for_each = var.deployment_role_arn == null ? [] : [var.deployment_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = "transaction-exchange-dev-eks-observability"
    }
  }
  default_tags {
    tags = merge({
      Application = "transaction-exchange"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }, var.tags)
  }
}

data "aws_eks_cluster_auth" "this" { name = data.aws_eks_cluster.this.name }

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

