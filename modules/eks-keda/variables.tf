variable "keda_version" {
  description = "Pinned KEDA Helm chart version."
  type        = string
  default     = "2.20.2"
}

variable "namespace" {
  description = "Namespace containing the KEDA operator components."
  type        = string
  default     = "keda"
}

variable "tags" {
  description = "Labels applied to the KEDA namespace."
  type        = map(string)
  default     = {}
}

