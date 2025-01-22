# Obtener la VPC predeterminada
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16" # Red principal
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}
/*
data "aws_vpc" "default" {
  default = true
}
*/

# Internet Gateway asociado a la VPC existente
/*
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
*/

# Crear una subred pública en la zona de disponibilidad "eu-west-3a"
resource "aws_subnet" "public_subnet_uno" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24" # Asegúrate de que no solape con el CIDR de otras subredes
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet Uno"
  }
}

# Crear una subred pública en la zona de disponibilidad "eu-west-3b"
resource "aws_subnet" "public_subnet_dos" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24" # Asegúrate de que no solape con el CIDR de otras subredes
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet Dos"
  }
}

# Crear una subred privada en la zona de disponibilidad "eu-west-3a"
resource "aws_subnet" "private_subnet_uno" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Private Subnet Uno"
  }
}

# Crear una subred privada en la zona de disponibilidad "eu-west-3b"
resource "aws_subnet" "private_subnet_dos" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "Private Subnet Dos"
  }
}

# Grupo de subredes para RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "docker-mysql-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_uno.id,
    aws_subnet.private_subnet_dos.id
  ]

  tags = {
    Name = "MySQL DB Subnet Group"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id # Asociamos el Internet Gateway al VPC creado explícitamente
  tags = {
    Name = "main-vpc-igw"
  }
}