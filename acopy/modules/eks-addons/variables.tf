variable "cluster_name" { type = string }
variable "addon_versions" { type = map(string) }
variable "ebs_kms_key_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
