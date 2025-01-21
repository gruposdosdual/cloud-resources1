/*


# RDS Instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  #storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "password123" # Cambia por una contraseña segura
  publicly_accessible  = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  identifier           = "db-rds-jgl"

  tags = {
    Name        = "rds-instance"
    Environment = "feature/add-resources"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "rds-subnet-group"
  }
}
*/




# EC2 Instance

resource "aws_instance" "ec2_instance" {
  ami           = "ami-09be70e689bddcef5" # Cambia por la AMI adecuada para tu entorno
  instance_type = "t3.small"
  key_name      = "my-aws-key"
  subnet_id     = module.vpc.public_subnets[0] # Utiliza la primera subred pública creada por el módulo VPC

  associate_public_ip_address = true

  depends_on = [module.vpc]

  tags = {
    Name       = "ec2-instance"
    Environment = "feature/add-resources"
  }

}

  

# Provisioner
resource "null_resource" "provision_file" {
  depends_on = [aws_instance.ec2_instance]
  
  # Copiar el archivo install.yaml a la instancia remota
  provisioner "file" {
    source      = "install.yaml"
    destination = "/home/ubuntu/install.yaml"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.ec2_instance.public_ip
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
      host        = aws_instance.ec2_instance.public_ip
      timeout     = "5m"
    }
  }
  # Ejecutar el playbook de Ansible
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.ec2_instance.public_ip
      timeout     = "5m"
    }

    inline = [
      "echo 'Starting Ansible setup...'",
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-playbook -i 'localhost,' -c local /home/ubuntu/install.yaml"

    ]
  }
}  

















/*
  # Opcional: Asocia una clave SSH para acceso remoto
  key_name = aws_key_pair.ssh_keypair.key_name
}

resource "aws_key_pair" "ssh_keypair" {
  key_name   = "my-aws-key" # Nombre de la clave existente
  public_key = file("~/.ssh/my-aws-key.pem")
  

  lifecycle {
    ignore_changes = [key_name] # Ignora cambios en la clave
  }
}

*/


/*
resource "aws_key_pair" "ssh_keypair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/id_rsa.pub") # Asegúrate de tener tu clave pública generada localmente # private_key = file("~/.ssh/my-aws-key.pem")
}
*/