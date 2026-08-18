provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Application = var.project_name
        Environment = "bootstrap"
        ManagedBy   = "Terraform"
      },
      var.tags
    )
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

