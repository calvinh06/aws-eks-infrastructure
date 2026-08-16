data "aws_iam_policy_document" "deployment_assume_role" {
  statement {
    sid     = "TrustedDeploymentPrincipals"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }
  }
}

data "aws_iam_policy_document" "plan_state_access" {
  statement {
    sid       = "ListStateBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid       = "ReadStateObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    sid    = "ManageStateLocks"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*.tflock"]
  }

  statement {
    sid    = "UseStateEncryptionKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [aws_kms_key.terraform_state.arn]
  }
}

data "aws_iam_policy_document" "apply_state_access" {
  statement {
    sid       = "ListStateBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid    = "ManageStateObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    sid    = "UseStateEncryptionKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [aws_kms_key.terraform_state.arn]
  }
}

resource "aws_iam_policy" "plan_state_access" {
  name        = "${var.project_name}-terraform-plan-state-access"
  description = "Read-only state access plus native lock management for Terraform plans"
  policy      = data.aws_iam_policy_document.plan_state_access.json
}

resource "aws_iam_policy" "apply_state_access" {
  name        = "${var.project_name}-terraform-apply-state-access"
  description = "Read and write access to the ${var.project_name} Terraform state backend"
  policy      = data.aws_iam_policy_document.apply_state_access.json
}

resource "aws_iam_role" "terraform_plan" {
  name                 = "${var.project_name}-terraform-plan"
  assume_role_policy   = data.aws_iam_policy_document.deployment_assume_role.json
  permissions_boundary = var.permissions_boundary_arn
  max_session_duration = var.role_max_session_duration_seconds
}

resource "aws_iam_role" "terraform_apply" {
  name                 = "${var.project_name}-terraform-apply"
  assume_role_policy   = data.aws_iam_policy_document.deployment_assume_role.json
  permissions_boundary = var.permissions_boundary_arn
  max_session_duration = var.role_max_session_duration_seconds
}

resource "aws_iam_role_policy_attachment" "plan_state_access" {
  role       = aws_iam_role.terraform_plan.name
  policy_arn = aws_iam_policy.plan_state_access.arn
}

resource "aws_iam_role_policy_attachment" "apply_state_access" {
  role       = aws_iam_role.terraform_apply.name
  policy_arn = aws_iam_policy.apply_state_access.arn
}

resource "aws_iam_role_policy_attachment" "plan_read_only" {
  role       = aws_iam_role.terraform_plan.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "plan_additional" {
  for_each = var.plan_managed_policy_arns

  role       = aws_iam_role.terraform_plan.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "apply_additional" {
  for_each = var.apply_managed_policy_arns

  role       = aws_iam_role.terraform_apply.name
  policy_arn = each.value
}
