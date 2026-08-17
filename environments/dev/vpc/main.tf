module "vpc" {
  source = "../../../modules/vpc"

  name     = "transaction-exchange-dev"
  vpc_cidr = "10.1.0.0/16"

  availability_zones = [
    "us-east-2a",
    "us-east-2b"
  ]

  public_subnet_cidrs = {
    us-east-2a = "10.1.0.0/24"
    us-east-2b = "10.1.1.0/24"
  }

  private_eks_subnet_cidrs = {
    us-east-2a = "10.1.16.0/20"
    us-east-2b = "10.1.32.0/20"
  }

  private_data_subnet_cidrs = {
    us-east-2a = "10.1.48.0/20"
    us-east-2b = "10.1.64.0/20"
  }

  nat_gateway_mode          = "single"
  enable_s3_gateway_endpoint = true

  tags = var.tags
}
