output "addon_versions" { value = module.eks_addons.addon_versions }
output "vpc_cni_role_arn" { value = module.eks_addons.vpc_cni_role_arn }
output "ebs_csi_role_arn" { value = module.eks_addons.ebs_csi_role_arn }
