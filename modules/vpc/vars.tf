variable "vpc_cidr" {
	default = "0.0.0.0/16"
}

variable "subnet_cidr_public" {
	type = "string"
	description = "Define CIDR block for public subnet"
	default = "10.0.1.0/24"
}

variable "subnet_cidr_private" {
	type = "string"
	description = "Define CIDR block for private subnet"
	default = "10.0.100.0/24"
}

variable "a_zone" {
	default = "us-east-2a"
}

