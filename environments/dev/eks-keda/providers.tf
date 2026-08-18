data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

locals {
  eks_token_arguments = concat(
    ["eks", "get-token", "--region", var.aws_region, "--cluster-name", var.cluster_name],
    var.deployment_role_arn == null ? [] : ["--role-arn", var.deployment_role_arn]
  )
}

provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.deployment_role_arn == null ? [] : [var.deployment_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = "transaction-exchange-dev-eks-keda"
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

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = local.eks_token_arguments
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = local.eks_token_arguments
    }
  }
}

