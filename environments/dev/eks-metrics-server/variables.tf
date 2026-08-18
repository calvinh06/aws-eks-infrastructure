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
  default = "3.13.1"
}

variable "replicas" {
  type    = number
  default = 2
}

variable "timeout_seconds" {
  type    = number
  default = 300
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "200Mi"
    }
    limits = {
      cpu    = "250m"
      memory = "500Mi"
    }
  }
}

variable "extra_args" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
