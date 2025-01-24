resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-subnet-group"
  #subnet_ids = ["subnet-0ed7f58c541c284ee", "subnet-03e43c39b3e2b6adc"]
  #subnet_ids = ["subnet-0ca2066e2d5f1a1cd", "subnet-03e43c39b3e2b6adc"]
  subnet_ids = ["subnet-0db83f9cfe117f3ee", "subnet-0c9cbb71f54b20838","subnet-09e322a40eca323b9"]
}

resource "aws_db_instance" "wordpress" {
  identifier           = "wordpress-database"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "wordpress"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}