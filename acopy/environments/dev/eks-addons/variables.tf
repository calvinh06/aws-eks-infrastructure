variable "aws_region" { default = "us-east-2" }
variable "deployment_role_arn" { default = null }
variable "tags" {
  type    = map(string)
  default = {}
}
