### This file configures state and providers


### AWS provider
provider "aws" {
  region = "${var.AWSRegion}"
}

### Required for Terragrunt to set up the correct statefile
terraform {
  backend "s3" {}
}
