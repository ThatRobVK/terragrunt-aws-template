### This file contains the resources to build. Additional files can be created to gain better separation within the module.

### Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.VpcCidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.Environment}-${var.VpcName}-vpc"
    Description = "${var.Environment} VPC"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}

### Flow log for VPC
resource "aws_flow_log" "vpc_flow_log" {
  count          = "${var.FlowLogEnabled}"
  log_group_name = "${var.FlowLogGroupName}"
  iam_role_arn   = "${data.terraform_remote_state.iam.flow_log_role_arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "${var.FlowLogTrafficType}"
}


### Internet Gateway for the vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.Environment}-${var.VpcName}-igw"
    Description = "Internet Gateway for ${var.Environment} ${var.VpcName}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}


### Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = "${length(var.PublicSubnetCidrs)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(var.AvailabilityZones, count.index)}"
  cidr_block              = "${element(var.PublicSubnetCidrs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.Environment}-${var.VpcName}-public-sn-${element(var.AvailabilityZones, count.index)}"
    Description = "Public Subnet for ${element(var.AvailabilityZones, count.index)} in ${var.Environment} ${var.VpcName}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}

resource "aws_route_table" "public_subnet_routetables" {
  count  = "${length(var.PublicSubnetCidrs)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.Environment}-${var.VpcName}-public-rt-${element(var.AvailabilityZones, count.index)}"
    Description = "Route table for public subnet for ${element(var.AvailabilityZones, count.index)} in ${var.Environment} ${var.VpcName}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}

resource "aws_route" "public_subnet_route" {
  count                  = "${length(var.PublicSubnetCidrs)}"
  route_table_id         = "${element(aws_route_table.public_subnet_routetables.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_route_table.public_subnet_routetables"]
}

resource "aws_route_table_association" "public_subnet_routetableassoc" {
  count          = "${length(var.PublicSubnetCidrs)}"
  route_table_id = "${element(aws_route_table.public_subnet_routetables.*.id, count.index)}"
  subnet_id      = "${element(concat(aws_subnet.public_subnets.*.id, list("")), count.index)}"
}

resource "aws_eip" "public_nat_gateway_eips" {
  count      = "${length(var.PublicSubnetCidrs)}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "public_nat_gateways" {
  count         = "${length(var.PublicSubnetCidrs)}"
  allocation_id = "${element(aws_eip.public_nat_gateway_eips.*.id, count.index)}"
  subnet_id     = "${element(concat(aws_subnet.public_subnets.*.id, list("")), count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags {
    Name        = "${var.Environment}-${var.VpcName}-nat-${element(var.AvailabilityZones, count.index)}"
    Description = "Public NAT gateway for ${element(var.AvailabilityZones, count.index)} in ${var.Environment} ${var.VpcName}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}


### Private route tables
resource "aws_route_table" "private_subnet_routetables" {
  count            = "${length(var.AvailabilityZones)}"
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${aws_vpn_gateway.vpn_gw.id}"]

  tags {
    Name        = "${var.Environment}-${var.VpcName}-private-rt-${element(var.AvailabilityZones, count.index)}"
    Description = "Private Subnet Routing Table ${element(var.AvailabilityZones, count.index)}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}

resource "aws_route" "private_subnet_to_public_nat_gateway_routes" {
  count                  = "${length(var.AvailabilityZones)}"
  route_table_id         = "${element(aws_route_table.private_subnet_routetables.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.public_nat_gateways.*.id, count.index)}"
}


### Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = "${length(var.PrivateSubnetCidrs)}"
  availability_zone = "${element(var.AvailabilityZones, count.index)}"
  cidr_block        = "${element(var.PrivateSubnetCidrs, count.index)}"
  vpc_id            = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.Environment}-${var.VpcName}-private-sn-${element(var.AvailabilityZones, count.index)}"
    Description = "Private Subnet for ${element(var.AvailabilityZones, count.index)} in ${var.Environment} ${var.VpcName}"
    Department  = "${var.TagDepartment}"
    Project     = "${var.TagProject}"
    Owner       = "${var.TagOwner}"
    Environment = "${var.TagEnvironment}"
    Retain      = "${var.TagRetain}"
  }
}

resource "aws_route_table_association" "private_subnets_routetableassoc" {
  count          = "${length(var.PrivateSubnetCidrs)}"
  route_table_id = "${element(aws_route_table.private_subnets_routetables.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
}

