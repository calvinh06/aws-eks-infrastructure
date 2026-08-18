module "eks_istio" {
  source                  = "../../../modules/eks-istio"
  istio_version           = var.istio_version
  gateway_service_type    = var.gateway_service_type
  install_ingress_gateway = var.install_ingress_gateway
  tags                    = var.tags
}
