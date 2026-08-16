variable "aws_region" {
  description = "AWS Region containing the Terraform state backend."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Stable project identifier used in resource names and tags."
  type        = string
  default     = "transaction-exchange"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,31}$", var.project_name))
    error_message = "project_name must start with a letter and contain 3-32 lowercase letters, numbers, or hyphens."
  }
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "state_bucket_name must be a valid globally unique S3 bucket name."
  }
}

variable "state_retention_days" {
  description = "Days to retain noncurrent state-object versions."
  type        = number
  default     = 365

  validation {
    condition     = var.state_retention_days >= 90
    error_message = "State history must be retained for at least 90 days."
  }
}

variable "trusted_principal_arns" {
  description = "IAM principals permitted to assume the Terraform plan and apply roles."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "At least one trusted IAM principal ARN is required."
  }
}

variable "permissions_boundary_arn" {
  description = "Optional organization-managed permission boundary applied to deployment roles."
  type        = string
  default     = null
}

variable "plan_managed_policy_arns" {
  description = "Additional managed policies for the Terraform plan role. ReadOnlyAccess is attached separately."
  type        = set(string)
  default     = []
}

variable "apply_managed_policy_arns" {
  description = "Organization-approved managed policies for the Terraform apply role. Empty by secure default."
  type        = set(string)
  default     = []
}

variable "role_max_session_duration_seconds" {
  description = "Maximum deployment-role session duration."
  type        = number
  default     = 3600

  validation {
    condition     = var.role_max_session_duration_seconds >= 3600 && var.role_max_session_duration_seconds <= 43200
    error_message = "Session duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  description = "Additional tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}

