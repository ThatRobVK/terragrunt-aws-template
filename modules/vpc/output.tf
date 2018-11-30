### This file defines the values that get output into the state, which can be utilised by other modules by refering to the remote state

### VPC outputs
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_name" {
  value = "${var.VpcName}"
}

output "vpc_igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "vpc_aws_account" {
  value = "${var.AWSAccount}"
}

### Subnet outputs
output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}

### Route outputs
output "public_subnet_routetable_ids" {
  value = ["${aws_route_table.public_subnet_routetables.*.id}"]
}

output "private_subnet_routetable_ids" {
  value = ["${aws_route_table.private_subnet_routetables.*.id}"]
}

output "public_nat_gateway_eips" {
  value = "${aws_eip.public_nat_gateway_eips.*.public_ip}"
}