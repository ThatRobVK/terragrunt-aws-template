### This file defines the variables that the module requires.

variable "AWSAccount" {
  description = "The account number this VPC resides in."
}

variable "AWSRegion" {
  description = "The AWS region this is being run in, e.g. \"eu-west-1\""
}

variable "AvailabilityZones" {
  type    = "list"
  default = []
  description = "A list of Availability Zones within the Region that should be used. E.g. \"eu-west-1a\", \"eu-west-1b\", etc."
}

variable "VpcCidr" {
  description = "The CIDR block the VPC should take on, e.g. 10.0.0.0/16"
}

variable "Environment" {
  description = "An environment within the AWS account, e.g. \"test\", \"preprod\", etc. This is used to build up resource names in AWS."
}

variable "VpcName" {
  description = "A name for the VPC that identifies it uniquely within the Environment. This is used to build up resource names in AWS."
}

variable "PublicSubnetCidrs" {
  type    = "list"
  default = []
  description = "A list of CIDR ranges for public subnets within the VPC. A subnet and associated resources is created for each CIDR in the list."
}

variable "PrivateSubnetCidrs" {
  type    = "list"
  default = []
  description = "A list of CIDR ranges for private subnets within the VPC. A subnet and associated resources is created for each CIDR in the list."
}


### VPC Flow Logs
variable FlowLogEnabled {
  description = "Enables or disables the VPC flow logs. Only use 1 (enable) or 0 (disable)."
}

variable FlowLogTrafficType {
  description = "The traffic type of the flow log. Can be ACCEPT, REJECT, or ALL."
}

variable FlowLogGroupName {
  description = "A CloudWatch Logs LogGroup name to output the VPC flow logs to."
}


### Tags
variable "TagDepartment" {
  description = "The department that owns this resource."
}
variable "TagProject" {
  description = "The project that has created this resource."
}
variable "TagOwner" {
  description = "The owner of the resource, e.g. a name or e-mail address."
}
variable "TagEnvironment" {
  description = "A user-friendly name for the environment, which is only used in tags. E.g. \"UAT environment for external users\"."
}
variable "TagRetain" {
  default = "null"
  description = "A flag that can be used to ensure resources are not removed by clean-up processes, if you implement these."
}
