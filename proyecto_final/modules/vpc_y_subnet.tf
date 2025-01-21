# Obtener la VPC predeterminada
data "aws_vpc" "default" {
  default = true
}

# Internet Gateway asociado a la VPC existente
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Crear una subred pública en la zona de disponibilidad "eu-west-3a"
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.0.0/20" # Asegúrate de que no solape con el CIDR de otras subredes
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

# Crear una subred pública en la zona de disponibilidad "eu-west-3b"
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.16.0/20" # Asegúrate de que no solape con el CIDR de otras subredes
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet B"
  }
}

# Crear una subred privada en la zona de disponibilidad "eu-west-3a"
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.32.0/20"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Private Subnet A"
  }
}

# Crear una subred privada en la zona de disponibilidad "eu-west-3b"
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "Private Subnet B"
  }
}

# Grupo de subredes para RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mr1-mysql-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "MySQL DB Subnet Group"
  }
}
