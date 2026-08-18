output "kms_key_arns" {
  value = module.security.kms_key_arns
}

output "platform_workloads_security_group_id" {
  value = module.security.platform_workloads_security_group_id
}

output "msk_security_group_id" {
  value = module.security.msk_security_group_id
}

output "aurora_security_group_id" {
  value = module.security.aurora_security_group_id
}

output "vpc_id" {
  value = data.aws_vpc.environment.id
}
