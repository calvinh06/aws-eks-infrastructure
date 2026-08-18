variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "cluster_name" {
  type    = string
  default = "transaction-exchange-dev"
}

variable "keda_version" {
  type    = string
  default = "2.20.2"
}

variable "deployment_role_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

