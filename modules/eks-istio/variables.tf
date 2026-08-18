variable "istio_version" {
  description = "Pinned Istio Helm chart version."
  type        = string
  default     = "1.30.3"
}

variable "system_namespace" {
  description = "Namespace containing the Istio control plane."
  type        = string
  default     = "istio-system"
}

variable "ingress_namespace" {
  description = "Namespace containing the Istio ingress gateway."
  type        = string
  default     = "istio-ingress"
}

variable "gateway_service_type" {
  description = "Kubernetes Service type for the ingress gateway. ClusterIP avoids an AWS load balancer charge."
  type        = string
  default     = "ClusterIP"
  validation {
    condition     = contains(["ClusterIP", "LoadBalancer"], var.gateway_service_type)
    error_message = "gateway_service_type must be ClusterIP or LoadBalancer."
  }
}

variable "install_ingress_gateway" {
  description = "Install the Istio ingress gateway Helm release."
  type        = bool
  default     = true
}

variable "pilot_resources" {
  description = "CPU and memory requests and limits for istiod."
  type = object({
    requests = map(string)
    limits   = map(string)
  })
  default = {
    requests = { cpu = "100m", memory = "256Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}

variable "gateway_resources" {
  description = "CPU and memory requests and limits for the ingress gateway."
  type = object({
    requests = map(string)
    limits   = map(string)
  })
  default = {
    requests = { cpu = "100m", memory = "128Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}

variable "tags" {
  description = "Labels applied to namespaces managed by this module."
  type        = map(string)
  default     = {}
}
