variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "deployment_role_arn" {
  type    = string
  default = null
}

variable "cluster_admin_principal_arn" {
  type = string
}

variable "endpoint_public_access_cidrs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
