output "kms_key_arns" {
  description = "KMS key ARNs keyed by purpose."
  value       = { for purpose, key in aws_kms_key.this : purpose => key.arn }
}

output "kms_key_ids" {
  description = "KMS key IDs keyed by purpose."
  value       = { for purpose, key in aws_kms_key.this : purpose => key.key_id }
}

output "platform_workloads_security_group_id" {
  description = "Security group used by EKS platform workloads."
  value       = aws_security_group.platform_workloads.id
}

output "msk_security_group_id" {
  description = "Security group used by MSK brokers."
  value       = aws_security_group.msk.id
}

output "aurora_security_group_id" {
  description = "Security group used by Aurora."
  value       = aws_security_group.aurora.id
}
