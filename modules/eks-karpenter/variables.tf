variable "aws_region" { type = string }
variable "cluster_name" { type = string }
variable "cluster_arn" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_security_group_ids" { type = list(string) }
variable "controller_node_group_name" { type = string }

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "chart_version" {
  type    = string
  default = "1.9.2"
}

variable "controller_replicas" {
  type    = number
  default = 2
}

variable "controller_resources" {
  type = object({
    requests = map(string)
    limits   = map(string)
  })
  default = {
    requests = { cpu = "200m", memory = "256Mi" }
    limits   = { cpu = "1", memory = "1Gi" }
  }
}

variable "timeout_seconds" {
  type    = number
  default = 600
}

variable "node_class_name" {
  type    = string
  default = "default"
}

variable "node_pool_name" {
  type    = string
  default = "default"
}

variable "ami_alias" {
  description = "EKS-optimized AMI alias. Pin a tested AMI version in production."
  type        = string
  default     = "al2023@latest"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium", "t3.large", "m5.large", "m6i.large"]
}

variable "cpu_limit" {
  type    = string
  default = "20"
}

variable "memory_limit" {
  type    = string
  default = "80Gi"
}

variable "consolidation_after" {
  type    = string
  default = "1m"
}

variable "expire_after" {
  type    = string
  default = "168h"
}

variable "root_volume_size" {
  type    = string
  default = "30Gi"
}

variable "node_labels" {
  type    = map(string)
  default = { "workload-tier" = "application" }
}

variable "tags" {
  type    = map(string)
  default = {}
}
