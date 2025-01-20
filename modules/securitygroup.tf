resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambiar si quieres restringir el acceso SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow-ssh"
    Environment = "feature/add-resources"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "allow-mysql-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Solo permite acceso desde la VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow-mysql"
    Environment = "feature/add-resources"
  }
}
