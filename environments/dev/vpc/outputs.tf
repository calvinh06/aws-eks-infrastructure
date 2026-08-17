output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_eks_subnet_ids" {
  value = module.vpc.private_eks_subnet_ids
}

output "private_data_subnet_ids" {
  value = module.vpc.private_data_subnet_ids
}

output "availability_zones" {
  value = module.vpc.availability_zones
}
