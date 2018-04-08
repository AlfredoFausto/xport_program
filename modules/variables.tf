variable "region" {
	type = "string"
	description = "Set us-east-2 region"
	default = "us-east-2"
}

variable "web_server_port" {
	default = 8080
}

variable "ssh_server_port" {
	default = 22
}

variable "rds_server_port" {
	default = 9043
}