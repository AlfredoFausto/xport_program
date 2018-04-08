variable "ami" {
	default = "ami-25615740"
}

variable "instance" {
	description = "Instance type using t2.micro"
	default = "t2.micro"
}

variable "security_group_elb_id" {}

variable "security_group_instance_id" {}