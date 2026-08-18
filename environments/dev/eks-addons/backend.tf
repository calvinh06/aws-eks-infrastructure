terraform {
  backend "s3" {
    bucket       = "transaction-exchange-terraform-state-728915381261-us-east-2"
    key          = "arn:aws:kms:us-east-2:728915381261:key/6ec8139b-449e-43e4-9592-d90fe5ca249f"
    region       = "us-east-2"
    kms_key_id   = "arn:aws:kms:us-east-2:728915381261:key/6ec8139b-449e-43e4-9592-d90fe5ca249f"
    encrypt      = true
    use_lockfile = true
  }
}
