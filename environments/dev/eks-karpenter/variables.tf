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

variable "tags" {
  type    = map(string)
  default = {}
}
