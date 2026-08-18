terraform {
  backend "s3" {
    # Supply these values with -backend-config after the first local apply.
    # bucket       = "globally-unique-state-bucket"
    # key          = "transaction-exchange/bootstrap/terraform.tfstate"
    # region       = "us-east-2"
    # kms_key_id   = "arn:aws:kms:us-east-2:123456789012:key/example"
    # encrypt      = true
    # use_lockfile = true
  }
}

