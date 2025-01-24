resource "aws_security_group" "wordpress_rds_sg" {
  name        = "wordpress-rds-sg"
  description = "Security group for RDS to allow access from EKS"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ajusta esto según tu configuración de red o usa un Security Group de EKS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-subnet-group-v3"
  #subnet_ids =["subnet-03f5b0dc5550de2c4", "subnet-0ece7ad592169689c", "subnet-0de031bfa5831cae1"]
  subnet_ids = ["subnet-0ac761233ce029852", "subnet-028a82898c2ffc968"]
}

resource "aws_db_instance" "wordpress" {
  identifier           = "wordpress-database-fjgl"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro" #"db.t3.small"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "wordpress"
  username             = var.db_username
  password             = var.db_password
  publicly_accessible   = true
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.wordpress_rds_sg.id]

}