output "istio_version" { value = module.eks_istio.istio_version }
output "system_namespace" { value = module.eks_istio.system_namespace }
output "ingress_namespace" { value = module.eks_istio.ingress_namespace }
output "base_release_name" { value = module.eks_istio.base_release_name }
output "istiod_release_name" { value = module.eks_istio.istiod_release_name }
output "ingress_release_name" { value = module.eks_istio.ingress_release_name }
