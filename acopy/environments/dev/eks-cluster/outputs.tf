output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_arn" {
  value = module.eks_cluster.cluster_arn
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks_cluster.cluster_security_group_id
}

output "node_role_arn" {
  value = module.eks_cluster.node_role_arn
}

output "node_group_name" {
  value = module.eks_cluster.node_group_name
}
