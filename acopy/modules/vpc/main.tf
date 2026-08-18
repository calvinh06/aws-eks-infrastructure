locals {
  azs = toset(var.availability_zones)

  nat_gateway_azs = var.nat_gateway_mode == "none" ? toset([]) : (
    var.nat_gateway_mode == "single" ? toset([var.availability_zones[0]]) : local.azs
  )

  common_tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  for_each = local.azs

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = var.public_subnet_cidrs[each.key]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                     = "${var.name}-public-${each.key}"
    Tier                     = "public"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "private_eks" {
  for_each = local.azs

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = var.private_eks_subnet_cidrs[each.key]

  tags = merge(local.common_tags, {
    Name                              = "${var.name}-private-eks-${each.key}"
    Tier                              = "private-eks"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_subnet" "private_data" {
  for_each = local.azs

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = var.private_data_subnet_cidrs[each.key]

  tags = merge(local.common_tags, {
    Name = "${var.name}-private-data-${each.key}"
    Tier = "private-data"
  })
}

resource "aws_route_table" "public" {
  for_each = local.azs

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-public-${each.key}" })
}

resource "aws_route" "public_internet" {
  for_each = local.azs

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = local.azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_azs

  domain = "vpc"

  tags = merge(local.common_tags, { Name = "${var.name}-nat-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_azs

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(local.common_tags, { Name = "${var.name}-nat-${each.key}" })
}

resource "aws_route_table" "private_eks" {
  for_each = local.azs

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-eks-${each.key}" })
}

resource "aws_route" "private_eks_nat" {
  for_each = var.nat_gateway_mode == "none" ? toset([]) : local.azs

  route_table_id         = aws_route_table.private_eks[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.nat_gateway_mode == "single" ? (
    aws_nat_gateway.this[var.availability_zones[0]].id
  ) : aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private_eks" {
  for_each = local.azs

  subnet_id      = aws_subnet.private_eks[each.key].id
  route_table_id = aws_route_table.private_eks[each.key].id
}

resource "aws_route_table" "private_data" {
  for_each = local.azs

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-data-${each.key}" })
}

resource "aws_route_table_association" "private_data" {
  for_each = local.azs

  subnet_id      = aws_subnet.private_data[each.key].id
  route_table_id = aws_route_table.private_data[each.key].id
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_gateway_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = concat(
    [for route_table in aws_route_table.private_eks : route_table.id],
    [for route_table in aws_route_table.private_data : route_table.id]
  )

  tags = merge(local.common_tags, { Name = "${var.name}-s3" })
}

data "aws_region" "current" {}
