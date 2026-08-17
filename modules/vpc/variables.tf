variable "name" {
  description = "Name prefix applied to VPC resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,47}$", var.name))
    error_message = "name must contain 3-48 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC. EKS requires at least two."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "Provide at least two unique Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR keyed by Availability Zone."
  type        = map(string)
}

variable "private_eks_subnet_cidrs" {
  description = "Private EKS subnet CIDR keyed by Availability Zone."
  type        = map(string)
}

variable "private_data_subnet_cidrs" {
  description = "Private data subnet CIDR keyed by Availability Zone."
  type        = map(string)
}

variable "nat_gateway_mode" {
  description = "NAT topology: single for labs, per_az for resilient environments, or none."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az", "none"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single, per_az, or none."
  }
}

variable "enable_s3_gateway_endpoint" {
  description = "Create a no-hourly-cost S3 gateway endpoint for private route tables."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags applied to VPC resources."
  type        = map(string)
  default     = {}
}
