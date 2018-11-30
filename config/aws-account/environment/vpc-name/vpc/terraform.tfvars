### This file tells Terragrunt how to run, and defines module specific variables

terragrunt = {
  terraform {
    source = "../../../../modules//vpc" // note the double slash before the module name

    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy",
      ]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../../../common.tfvars",
        "-var-file=${get_tfvars_dir()}/../../common.tfvars",
        "-var-file=${get_tfvars_dir()}/../common.tfvars",
      ]
    }
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}


### Subnets
PublicSubnetCidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
PrivateSubnetCidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

### VPC Flow Logs
FlowLogEnabled = 1
FlowLogTrafficType = "ALL"
FlowLogGroupName = "VpcFlowLogs"