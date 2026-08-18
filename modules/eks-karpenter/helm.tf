resource "helm_release" "controller" {
  name       = "karpenter"
  namespace  = var.namespace
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = var.chart_version

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  timeout          = var.timeout_seconds
  wait             = true

  values = [
    yamlencode({
      replicas = var.controller_replicas
      settings = {
        clusterName       = var.cluster_name
        interruptionQueue = aws_sqs_queue.interruption.name
      }
      serviceAccount = {
        name = "karpenter"
      }
      nodeSelector = {
        "eks.amazonaws.com/nodegroup" = var.controller_node_group_name
      }
      resources = var.controller_resources
    })
  ]

  depends_on = [
    aws_eks_pod_identity_association.controller,
    aws_iam_role_policy_attachment.controller
  ]
}

resource "helm_release" "configuration" {
  name      = "karpenter-configuration"
  namespace = var.namespace
  chart     = "${path.module}/chart"

  atomic          = true
  cleanup_on_fail = true
  timeout         = var.timeout_seconds
  wait            = true

  values = [
    yamlencode({
      clusterName        = var.cluster_name
      nodeClassName      = var.node_class_name
      nodePoolName       = var.node_pool_name
      instanceProfile    = aws_iam_instance_profile.node.name
      securityGroupIds   = var.node_security_group_ids
      amiAlias           = var.ami_alias
      instanceTypes      = var.instance_types
      cpuLimit           = var.cpu_limit
      memoryLimit        = var.memory_limit
      consolidationAfter = var.consolidation_after
      expireAfter        = var.expire_after
      rootVolumeSize     = var.root_volume_size
      nodeLabels         = var.node_labels
    })
  ]

  depends_on = [
    helm_release.controller,
    aws_ec2_tag.subnet_discovery,
    aws_eks_access_entry.node,
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy_attachment.node_cni_bootstrap,
    aws_iam_role_policy_attachment.node_ssm
  ]
}
