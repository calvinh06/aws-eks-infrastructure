variable "aws_region" {
  type    = string
  default = "us-east-2"
}
variable "deployment_role_arn" {
  type    = string
  default = null
}
variable "chart_version" {
  type    = string
  default = null
}
variable "prometheus_retention" {
  type    = string
  default = "2d"
}
variable "prometheus_storage_enabled" {
  type    = bool
  default = false
}
variable "prometheus_storage_size" {
  type    = string
  default = "20Gi"
}
variable "grafana_storage_enabled" {
  type    = bool
  default = false
}
variable "grafana_storage_size" {
  type    = string
  default = "10Gi"
}
variable "storage_class_name" {
  type    = string
  default = "gp2"
}
variable "tags" {
  type    = map(string)
  default = {}
}

