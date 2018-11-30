Terraform module to build an AWS VPC.

This creates:
- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateways
- Route tables for public and private subnets
- Routes that allow egress to the internet via the IGW and NAT GWs
- VPC Flow Logs to CloudWatch

This module allows flexible configuration of:
- AWS Region and Availability Zones
- Number of public subnets and their CIDR ranges
- Number of private subnets and their CIDR ranges

This module isn't meant to capture anything you might want to do in a VPC, but rather a template that suits most basic setups and can be built upon for specific requirements.