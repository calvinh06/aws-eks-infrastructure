provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.deployment_role_arn == null ? [] : [var.deployment_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = "transaction-exchange-dev-metrics-server"
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

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        local.cluster_name,
        "--region",
        var.aws_region
      ]
    }
  }
}
