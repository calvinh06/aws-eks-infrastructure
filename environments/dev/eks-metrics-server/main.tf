locals {
  cluster_name = "transaction-exchange-dev"
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

module "metrics_server" {
  source = "../../../modules/metrics-server"

  chart_version   = var.chart_version
  replicas        = var.replicas
  timeout_seconds = var.timeout_seconds
  resources       = var.resources
  extra_args      = var.extra_args
}
