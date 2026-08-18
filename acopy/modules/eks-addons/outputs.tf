output "addon_versions" {
  value = {
    coredns                = aws_eks_addon.coredns.addon_version
    kube_proxy             = aws_eks_addon.kube_proxy.addon_version
    vpc_cni                = aws_eks_addon.vpc_cni.addon_version
    eks_pod_identity_agent = aws_eks_addon.pod_identity_agent.addon_version
    aws_ebs_csi_driver     = aws_eks_addon.ebs_csi.addon_version
  }
}

output "vpc_cni_role_arn" { value = aws_iam_role.vpc_cni.arn }
output "ebs_csi_role_arn" { value = aws_iam_role.ebs_csi.arn }
