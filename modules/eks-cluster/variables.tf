variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes minor version."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets in at least two Availability Zones."
}

variable "additional_security_group_ids" {
  type        = list(string)
  description = "Additional security groups attached to cluster and node ENIs."
  default     = []
}

variable "secrets_kms_key_arn" {
  type        = string
  description = "KMS key used for Kubernetes secret envelope encryption."
}

variable "cluster_admin_principal_arn" {
  type        = string
  description = "IAM principal granted cluster-administrator access."
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the public Kubernetes API endpoint."
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "EKS control-plane log types."
  default     = ["api", "audit", "authenticator"]
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch control-plane log retention."
  default     = 7
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types used by the managed node group."
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to EKS resources."
  default     = {}
}
