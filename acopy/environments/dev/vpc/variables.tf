variable "aws_region" {
  description = "AWS Region hosting the environment."
  type        = string
  default     = "us-east-2"
}

variable "deployment_role_arn" {
  description = "Optional Terraform deployment role to assume. Null uses the current AWS identity."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags applied to environment resources."
  type        = map(string)
  default     = {}
}
