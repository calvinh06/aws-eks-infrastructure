module "eks_keda" {
  source       = "../../../modules/eks-keda"
  keda_version = var.keda_version
  tags         = var.tags
}

