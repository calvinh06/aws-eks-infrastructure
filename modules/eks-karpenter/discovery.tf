resource "aws_ec2_tag" "subnet_discovery" {
  for_each = toset(var.subnet_ids)

  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}
