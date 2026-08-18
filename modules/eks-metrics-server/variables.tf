variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "metrics-server"
}

variable "namespace" {
  description = "Namespace in which Metrics Server is installed."
  type        = string
  default     = "kube-system"
}

variable "chart_version" {
  description = "Pinned Metrics Server Helm chart version."
  type        = string
  default     = "3.13.1"
}

variable "replicas" {
  description = "Number of Metrics Server replicas. Use two or more for availability."
  type        = number
  default     = 2

  validation {
    condition     = var.replicas >= 1
    error_message = "replicas must be at least 1."
  }
}

variable "timeout_seconds" {
  description = "Time allowed for the Helm release to become ready."
  type        = number
  default     = 300
}

variable "resources" {
  description = "Metrics Server pod resource requests and limits."
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
  description = "Additional Metrics Server command-line arguments."
  type        = list(string)
  default     = []
}
