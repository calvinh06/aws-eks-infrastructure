locals {
  common_tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_kms_key" "this" {
  for_each = var.kms_key_names

  description             = "${var.name} ${each.key} encryption key"
  deletion_window_in_days = var.kms_deletion_window_days
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name    = "${var.name}-${each.key}"
    Purpose = each.key
  })
}

resource "aws_kms_alias" "this" {
  for_each = var.kms_key_names

  name          = "alias/${var.name}-${each.key}"
  target_key_id = aws_kms_key.this[each.key].key_id
}

resource "aws_security_group" "platform_workloads" {
  name        = "${var.name}-platform-workloads"
  description = "EKS platform workload communication"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name}-platform-workloads"
  })
}

resource "aws_security_group" "msk" {
  name        = "${var.name}-msk"
  description = "MSK broker access from platform workloads"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name}-msk"
  })
}

resource "aws_security_group" "aurora" {
  name        = "${var.name}-aurora"
  description = "Aurora access from platform workloads"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name}-aurora"
  })
}

resource "aws_vpc_security_group_ingress_rule" "platform_self" {
  security_group_id            = aws_security_group.platform_workloads.id
  referenced_security_group_id = aws_security_group.platform_workloads.id
  ip_protocol                  = "-1"
  description                  = "Allow communication among platform workloads"
}

resource "aws_vpc_security_group_ingress_rule" "msk_from_platform" {
  security_group_id            = aws_security_group.msk.id
  referenced_security_group_id = aws_security_group.platform_workloads.id
  from_port                    = var.msk_iam_port
  to_port                      = var.msk_iam_port
  ip_protocol                  = "tcp"
  description                  = "MSK TLS IAM from platform workloads"
}

resource "aws_vpc_security_group_ingress_rule" "msk_self" {
  security_group_id            = aws_security_group.msk.id
  referenced_security_group_id = aws_security_group.msk.id
  ip_protocol                  = "-1"
  description                  = "Allow communication among MSK brokers"
}

resource "aws_vpc_security_group_ingress_rule" "aurora_from_platform" {
  security_group_id            = aws_security_group.aurora.id
  referenced_security_group_id = aws_security_group.platform_workloads.id
  from_port                    = var.aurora_port
  to_port                      = var.aurora_port
  ip_protocol                  = "tcp"
  description                  = "Aurora PostgreSQL from platform workloads"
}

resource "aws_vpc_security_group_egress_rule" "platform_ipv4" {
  security_group_id = aws_security_group.platform_workloads.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Platform workload outbound access"
}

resource "aws_vpc_security_group_egress_rule" "msk_ipv4" {
  security_group_id = aws_security_group.msk.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "MSK broker outbound access"
}

resource "aws_vpc_security_group_egress_rule" "aurora_ipv4" {
  security_group_id = aws_security_group.aurora.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Aurora outbound access"
}
