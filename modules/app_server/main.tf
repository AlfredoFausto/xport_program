resource "aws_instance" "hw_instance" {
	ami = "${var.ami}"
	instance_type = "${var.instance}"
	key_name = "test1"
	security_groups = ["${var.security_group_appServerInstance_id}"]
	user_data = <<-EOF
	  #!/bin/bash
	  yum update -y
	  yum install -y apache2
	  EOF

	tags { 
		Name = "App Server Apache 2"
	}
}