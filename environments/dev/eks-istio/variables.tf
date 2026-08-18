variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "cluster_name" {
  type    = string
  default = "transaction-exchange-dev"
}

variable "istio_version" {
  type    = string
  default = "1.30.3"
}

variable "gateway_service_type" {
  type    = string
  default = "ClusterIP"
}

variable "install_ingress_gateway" {
  type    = bool
  default = true
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
