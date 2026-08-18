data "aws_vpc" "environment" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  filter {
    name   = "tag:Environment"
    values = ["dev"]
  }
}

module "security" {
  source = "../../../modules/security"

  name   = "transaction-exchange-dev"
  vpc_id = data.aws_vpc.environment.id

  kms_key_names = [
    "application",
    "aurora",
    "msk",
    "secrets"
  ]

  kms_deletion_window_days = 7
  aurora_port              = 5432
  msk_iam_port             = 9098

  tags = var.tags
}
