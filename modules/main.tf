provider "aws" {
	region = "us-east-2"
}
terraform {
  backend "s3" {
    bucket = "tf-back-end"
    key    = "./aws/"
    region = "us-east-2"
  }
}

module "DB" {
	source = "./DBInstance/"
	db_port = "${var.rds_server_port}"
}

module "AutoScaling" {
	source = "./autoscaling/"
	security_group_elb_id = "${aws_security_group.elb.id}"
	security_group_instance_id = "${aws_security_group.instance.id}"
}

module "vpc" {
	source = "./vpc/"
}

module "appServer" {
	source = "./app_server/"
	security_group_appServerInstance_id = "${aws_security_group.instance.id}"
}

resource "aws_security_group" "instance" {
  name = "auto_scaling_security_group_tf"
  
  ingress {
    from_port = "${var.web_server_port}"
    to_port = "${var.web_server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "${var.ssh_server_port}"
    to_port = "${var.ssh_server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "${var.web_server_port}"
    to_port = "${var.web_server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-tr" {
  name = "terraform-example-rds"
  
  ingress {
    from_port = "${var.rds_server_port}"
    to_port = "${var.rds_server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

