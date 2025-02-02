resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Subnets públicas
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  cidr_block = element(var.public_subnet_cidr_blocks, count.index)
  vpc_id     = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-public-${count.index}"
  }
}

# Subnets privadas
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  vpc_id     = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.cluster_name}-private-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# NAT Gateway para las subnets privadas
resource "aws_eip" "this" {
  domain = "vpc" # vpc = true   # esta deprecado
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.this]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Seguridad: Grupos de Seguridad
resource "aws_security_group" "this" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for EKS and ALB"
  vpc_id      = aws_vpc.this.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}










/*

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "this" {
  count = length(var.subnet_cidr_blocks)

  cidr_block = element(var.subnet_cidr_blocks, count.index)
  vpc_id     = aws_vpc.this.id
  availability_zone = element(var.availability_zones, count.index)
}
*/