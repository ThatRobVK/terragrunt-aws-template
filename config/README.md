This folder hosts all the configs that use the modules. Create a subfolder here for each AWS account you want to control.

The folder structure is as follows:
- Config
  - Account # one for each account
    - Environment # one for each environment in this account
      - VPC_Name # one for each VPC in the environment
        - Modulename # one for each module to run in the VPC
          - terraform.tfvars # module config
        - common.tfvars # variables common across the VPC
      - common.tfvars # variables common across the environment
    - common.tfvars # variables common across the account
    - terraform.tfvars

