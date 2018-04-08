resource "aws_vpc" "terraform-vpc"{
	cidr_block = "${var.vpc_cidr}"
	instance_tenancy = "default"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	enable_classiclink = "false"
	
	tags {
		Name = "terraform"
	}
}

resource "aws_subnet" "public-1" {
	vpc_id = "${aws_vpc.terraform-vpc.id}"
	cidr_block = "${var.subnet_cidr_public}"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.a_zone}"
	
	tags {
		Name = "public"
	}
}

resource "aws_subnet" "private-1" {
	vpc_id = "${aws_vpc.terraform-vpc.id}"
	cidr_block = "${var.subnet_cidr_private}" 
	map_public_ip_on_launch = "false"
	availability_zone = "${var.a_zone}"
	
	tags {
		Name = "private"
	}
}

resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.terraform-vpc.id}"
	tags {
		Name = "internet-gateway"
	}
}

resource "aws_route_table" "rt1" {
	vpc_id = "${aws_vpc.terraform-vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gw.id}"
	}
	tags {
		Name = "Default"
	}
}

resource "aws_route_table_association" "association-subnet" {
	subnet_id = "${aws_subnet.public-1.id}"
	route_table_id = "${aws_route_table.rt1.id}"
}