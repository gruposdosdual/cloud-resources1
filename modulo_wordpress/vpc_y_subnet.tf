# Referenciar la VPC existente
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

# Subredes predeterminadas asociadas a la VPC
data "aws_subnet" "subnet_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["eu-west-3a"]
  }


# Si conoces el CIDR de la subred, agrega este filtro para hacerlo más específico
  filter {
    name   = "cidr-block"
    values = ["172.31.0.0/20"]  # Reemplaza con el CIDR correcto
  }
}


data "aws_subnet" "subnet_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["eu-west-3b"]
  }


# Si conoces el CIDR de la subred, agrega este filtro para hacerlo más específico
  filter {
    name   = "cidr-block"
    values = ["172.31.16.0/20"]  # Reemplaza con el CIDR correcto
  }
}

# Grupo de subredes para RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "new2-mysql-subnet-group-unique"
  subnet_ids = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id]

  tags = {
    Name = "MySQL DB subnet group"
  }

  lifecycle {
    create_before_destroy = true    
  }
}






/*



resource "aws_vpc" "main" {
  cidr_block           = "172.31.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true  # Importante para RDS
  enable_dns_support   = true  # Importante para RDS

  tags = {
    Name = "Default vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway-jgl"
  }
}

# Subnets para RDS (necesitamos al menos 2 para Multi-AZ)
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.31.0.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1-jgl"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.31.16.0/20"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-2-jgl"
  }
}

# Grupo de subnets para RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "MySQL DB subnet group"
  }

  lifecycle {
      create_before_destroy = true
      ignore_changes = [name]
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Table-jgl"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

*/