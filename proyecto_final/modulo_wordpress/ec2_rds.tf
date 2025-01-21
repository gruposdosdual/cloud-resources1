# RDS Instance
resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t4g.micro"
  db_name               = "mydb"
  username              = "admin"
  password              = "password123"
  publicly_accessible   = true
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_ssh3.id]
  identifier            =  "database-rds-jgl" 

  

  tags = {
    Name = "MySQL-Terraform-FJGL"
  }
}




# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-09be70e689bddcef5"
  instance_type = "t3.small"
  key_name      = "my-aws-key"
  disable_api_termination = true
  subnet_id     = data.aws_subnet.subnet_a.id #aws_subnet.subnet_1.id

  vpc_security_group_ids = [aws_security_group.allow_ssh3.id]
  #vpc_security_group_ids = [aws_security_group.allow_ssh2.id, aws_security_group.allow_http_https.id]


  associate_public_ip_address = true

  depends_on = [aws_security_group.allow_ssh3]



  tags = {
    Name = "WebServer-Terraform-FJGL"
  }
}


# Provisioner
resource "null_resource" "provision_file" {
  depends_on = [aws_instance.web_server]
  
  # Copiar el archivo install.yaml a la instancia remota
  provisioner "file" {
    source      = "install.yaml"
    destination = "/home/ubuntu/install.yaml"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.web_server.public_ip
      timeout     = "5m"
    }
  }
  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.web_server.public_ip
      timeout     = "5m"
    }
  }
  # Ejecutar el playbook de Ansible
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.web_server.public_ip
      timeout     = "5m"
    }

    inline = [
      "echo 'Starting Ansible setup...'",
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-playbook -i 'localhost,' -c local /home/ubuntu/install.yaml"
      /*"sudo yum update -y",
      "sudo amazon-linux-extras enable php7.4",
      "sudo yum install -y httpd php php-mysqlnd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "wget https://wordpress.org/latest.tar.gz",
      "tar -xvzf latest.tar.gz",
      "sudo mv wordpress/* /var/www/html/",
      "sudo chown -R apache:apache /var/www/html/*",
      "sudo sed -i 's/database_name_here/mydb/g /var/www/html/wp-config.php",
      "sudo sed -i 's/username_here/admin/g /var/www/html/wp-config.php",
      "sudo sed -i 's/password_here/password123/g' /var/www/html/wp-config.php",
      "sudo sed -i 's/localhost/${aws_db_instance.mysql_db.address}/g' /var/www/html/wp-config.php"*/
    ]
  }
  /*
  provisioner "local-exec" {
    command = "sudo reboot"
  }*/
}


/*
# Grupo de seguridad para MySQL
resource "aws_security_group" "allow_mysql2" {
  name        = "allow_mysql_new"
  description = "Allow MySQL inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow MySQL"
  }
}
*/