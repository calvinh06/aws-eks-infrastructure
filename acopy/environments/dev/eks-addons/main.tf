locals {
  cluster_name = "transaction-exchange-dev"
  addon_names = toset([
    "aws-ebs-csi-driver",
    "coredns",
    "eks-pod-identity-agent",
    "kube-proxy",
    "vpc-cni"
  ])
}

data "aws_eks_cluster" "this" { name = local.cluster_name }

data "aws_eks_addon_version" "compatible" {
  for_each           = local.addon_names
  addon_name         = each.key
  kubernetes_version = data.aws_eks_cluster.this.version
  most_recent        = true
}

data "aws_kms_alias" "application" {
  name = "alias/transaction-exchange-dev-application"
}

module "eks_addons" {
  source = "../../../modules/eks-addons"

  cluster_name    = local.cluster_name
  ebs_kms_key_arn = data.aws_kms_alias.application.target_key_arn
  addon_versions = {
    for name, version in data.aws_eks_addon_version.compatible : name => version.version
  }
  tags = var.tags
}
