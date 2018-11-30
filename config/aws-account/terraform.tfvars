### This file configures the state back-end for Terragrunt. It allows for multiple identical environments within an AWS account and avoids
### state file clashes. Edit the values below to suit your project.

terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "mycorp-awsaccount-tfstate"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "mycorp-awsaccount-tfstate"

      s3_bucket_tags {
        Name        = "Terraform state storage for MyCorp AWSAccount"
        Department  = "Engineering"
        Project     = "My Cloud Project"
        Owner       = "sysadmins@mycorp.com"
        Environment = "AWSAccount"
        Retain      = "true"
      }

      dynamodb_table_tags {
        Name        = "Terraform state lock for MyCorp AWSAccount"
        Department  = "Engineering"
        Project     = "My Cloud Project"
        Owner       = "sysadmins@mycorp.com"
        Environment = "AWSAccount"
        Retain      = "true"
      }
    }
  }
}
