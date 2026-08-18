output "vpc_id" {
  description = "VPC identifier."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC IPv4 CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet identifiers keyed by Availability Zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "private_eks_subnet_ids" {
  description = "Private EKS subnet identifiers keyed by Availability Zone."
  value       = { for az, subnet in aws_subnet.private_eks : az => subnet.id }
}

output "private_data_subnet_ids" {
  description = "Private data subnet identifiers keyed by Availability Zone."
  value       = { for az, subnet in aws_subnet.private_data : az => subnet.id }
}

output "nat_gateway_ids" {
  description = "NAT gateway identifiers keyed by Availability Zone."
  value       = { for az, nat_gateway in aws_nat_gateway.this : az => nat_gateway.id }
}

output "availability_zones" {
  description = "Availability Zones used by the VPC."
  value       = var.availability_zones
}
