provider "aws" {
  region = var.aws_region

  dynamic "assume_role" {
    for_each = var.deployment_role_arn == null ? [] : [var.deployment_role_arn]
    content {
      role_arn     = assume_role.value
      session_name = "transaction-exchange-dev-eks"
    }
  }

  default_tags {
    tags = merge({
      Application = "transaction-exchange"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }, var.tags)
  }
}
