#DB Instance

resource "aws_db_instance" "db-tier-tf" {
  allocated_storage = 20
  engine            = "PostgreSQL"
  engine_version    = "9.6.6-R1"
  instance_class    = "db.t2.micro"
  name              = "db-post-tf"
  license_model		= "postgresql-license"
  port				= "${var.db_port}"
}