resource "aws_instance" "ec2_instance" {
  ami           = "ami-09be70e689bddcef5" # Cambia por la AMI adecuada para tu entorno
  instance_type = "t3.small"
  subnet_id     = module.vpc.public_subnets[0] # Utiliza la primera subred pública creada por el módulo VPC

  tags = {
    Name       = "ec2-instance"
    Environment = "feature/add-resources"
  }

  # Opcional: Asocia una clave SSH para acceso remoto
  key_name = aws_key_pair.ssh_keypair.key_name
}

resource "aws_key_pair" "ssh_keypair" {
  key_name   = "my-aws-key"
  public_key = file("~/.ssh/id_rsa.pub") # Asegúrate de tener tu clave pública generada localmente # private_key = file("~/.ssh/my-aws-key.pem")
}
