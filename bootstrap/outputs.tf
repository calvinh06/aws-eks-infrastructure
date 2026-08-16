output "aws_account_id" {
  description = "AWS account in which bootstrap resources were created."
  value       = data.aws_caller_identity.current.account_id
}

output "state_bucket_name" {
  description = "S3 bucket used by Terraform backends."
  value       = aws_s3_bucket.terraform_state.id
}

output "state_kms_key_arn" {
  description = "KMS key used to encrypt Terraform state."
  value       = aws_kms_key.terraform_state.arn
}

output "terraform_plan_role_arn" {
  description = "Role used for Terraform plan operations."
  value       = aws_iam_role.terraform_plan.arn
}

output "terraform_apply_role_arn" {
  description = "Role used for approved Terraform apply operations."
  value       = aws_iam_role.terraform_apply.arn
}

output "backend_configuration" {
  description = "Values used to configure an S3 backend in later targets."
  value = {
    bucket       = aws_s3_bucket.terraform_state.id
    region       = var.aws_region
    kms_key_id   = aws_kms_key.terraform_state.arn
    encrypt      = true
    use_lockfile = true
  }
}

