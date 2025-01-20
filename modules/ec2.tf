resource "aws_instance" "ec2_instance" {
  ami           = "ami-09be70e689bddcef5" # Cambia por la AMI adecuada para tu entorno
  instance_type = "t3.small"
  subnet_id     = module.vpc.public_subnets[0] # Utiliza la primera subred pública creada por el módulo VPC

  tags = {
    Name       = "ec2-instance"
    Environment = "feature/add-resources"
  }

  depends_on = [module.vpc]
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