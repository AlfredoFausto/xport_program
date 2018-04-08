#AutoScaling

data "aws_availability_zones" "all" {}

resource "aws_elb" "elb-tf" {
  name = "terraform-asg-example"
  security_groups = ["${var.security_group_elb_id}"]
  #["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 3
    interval = 30
    target = "HTTP:80/index.html"
  }
  
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
}

resource "aws_launch_configuration" "lunch_configuration_tf" {
  image_id = "${var.ami}"
  instance_type = "${var.instance}"
  key_name = "test1"
  security_groups = ["${var.security_group_instance_id}"]
  #["${aws_security_group.instance.id}"]
  user_data = <<-EOF
	  #!/bin/bash
	  yum update -y
	  yum install -y httpd
	  service httpd start
	  echo "New instance created" > /var/www/html/index.html
	  EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-tf" {
  launch_configuration = "${aws_launch_configuration.lunch_configuration_tf.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  desired_capacity   = 2
  min_size = 1
  max_size = 3
  
  load_balancers = ["${aws_elb.elb-tf.name}"]
  health_check_type = "ELB"
  
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}


