data "aws_vpc" "environment" {
  filter {
    name   = "tag:Name"
    values = ["transaction-exchange-dev"]
  }
}

data "aws_subnets" "private_eks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.environment.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["private-eks"]
  }
}

data "aws_security_group" "platform_workloads" {
  vpc_id = data.aws_vpc.environment.id
  name   = "transaction-exchange-dev-platform-workloads"
}

data "aws_kms_alias" "secrets" {
  name = "alias/transaction-exchange-dev-secrets"
}

module "eks_cluster" {
  source = "../../../modules/eks-cluster"

  cluster_name       = "transaction-exchange-dev"
  kubernetes_version = "1.35"
  subnet_ids         = sort(data.aws_subnets.private_eks.ids)

  additional_security_group_ids = [data.aws_security_group.platform_workloads.id]
  secrets_kms_key_arn           = data.aws_kms_alias.secrets.target_key_arn
  cluster_admin_principal_arn   = var.cluster_admin_principal_arn
  endpoint_public_access_cidrs  = var.endpoint_public_access_cidrs

  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 3

  tags = var.tags
}
