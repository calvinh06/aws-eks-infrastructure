variable "name" {
  description = "Name prefix applied to security resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,47}$", var.name))
    error_message = "name must contain 3-48 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "vpc_id" {
  description = "VPC in which security groups are created."
  type        = string
}

variable "kms_key_names" {
  description = "Purpose names for customer-managed KMS keys."
  type        = set(string)
  default     = ["application", "aurora", "msk", "secrets"]

  validation {
    condition     = length(var.kms_key_names) > 0
    error_message = "Create at least one purpose-specific KMS key."
  }
}

variable "kms_deletion_window_days" {
  description = "KMS key deletion waiting period."
  type        = number
  default     = 7

  validation {
    condition     = var.kms_deletion_window_days >= 7 && var.kms_deletion_window_days <= 30
    error_message = "kms_deletion_window_days must be between 7 and 30."
  }
}

variable "aurora_port" {
  description = "Aurora listener port allowed from platform workloads."
  type        = number
  default     = 5432
}

variable "msk_iam_port" {
  description = "MSK TLS/IAM listener port allowed from platform workloads."
  type        = number
  default     = 9098
}

variable "tags" {
  description = "Additional tags applied to security resources."
  type        = map(string)
  default     = {}
}
