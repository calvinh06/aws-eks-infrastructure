variable "release_name" {
  type    = string
  default = "kube-prometheus-stack"
}
variable "namespace" {
  type    = string
  default = "observability"
}
variable "chart_version" {
  description = "Chart version; null installs the latest available version."
  type        = string
  default     = null
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
variable "helm_timeout_seconds" {
  type    = number
  default = 900
}

