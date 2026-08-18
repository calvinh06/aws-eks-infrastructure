locals { cluster_name = "transaction-exchange-dev" }

data "aws_eks_cluster" "this" { name = local.cluster_name }

module "eks_observability" {
  source = "../../../modules/eks-observability"
  chart_version              = var.chart_version
  prometheus_retention       = var.prometheus_retention
  prometheus_storage_enabled = var.prometheus_storage_enabled
  prometheus_storage_size    = var.prometheus_storage_size
  grafana_storage_enabled    = var.grafana_storage_enabled
  grafana_storage_size       = var.grafana_storage_size
  storage_class_name         = var.storage_class_name
}

