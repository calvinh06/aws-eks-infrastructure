locals {
  cluster_name = "transaction-exchange-dev"
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_vpc" "environment" {
  filter {
    name   = "tag:Name"
    values = [local.cluster_name]
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
  name   = "${local.cluster_name}-platform-workloads"
}

module "karpenter" {
  source = "../../../modules/eks-karpenter"

  aws_region   = var.aws_region
  cluster_name = data.aws_eks_cluster.this.name
  cluster_arn  = data.aws_eks_cluster.this.arn
  subnet_ids   = sort(data.aws_subnets.private_eks.ids)

  node_security_group_ids = [
    data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
    data.aws_security_group.platform_workloads.id
  ]
  controller_node_group_name = "default"
  chart_version              = var.chart_version
  controller_replicas        = var.controller_replicas
  controller_resources       = var.controller_resources
  instance_types             = var.instance_types
  cpu_limit                  = var.cpu_limit
  memory_limit               = var.memory_limit
  consolidation_after        = var.consolidation_after
  expire_after               = var.expire_after
  root_volume_size           = var.root_volume_size
  tags                       = var.tags

}

check "karpenter_security_groups" {
  assert {
    condition = alltrue([
      for id in [
        data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
        data.aws_security_group.platform_workloads.id
      ] : startswith(id, "sg-")
    ])

    error_message = "Karpenter requires valid EKS cluster and platform workload security-group IDs."
  }
}