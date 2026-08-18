output "controller_role_arn" { value = module.karpenter.controller_role_arn }
output "node_role_arn" { value = module.karpenter.node_role_arn }
output "node_instance_profile_name" { value = module.karpenter.node_instance_profile_name }
output "interruption_queue_name" { value = module.karpenter.interruption_queue_name }
output "chart_version" { value = module.karpenter.chart_version }
output "node_class_name" { value = module.karpenter.node_class_name }
output "node_pool_name" { value = module.karpenter.node_pool_name }
