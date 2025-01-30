provider "aws" {
  region = "eu-west-1"
  profile = "248189943700_EKS-alumnos"
}

provider "random" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"  # AZ 1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1b"  # AZ 2
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

/*
resource "aws_subnet" "ecs_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
}
*/

resource "aws_subnet" "rds_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "RDS Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id
  
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = ["10.0.0.0/16"]
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "mydb"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username              = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  password              = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.rds_subnet.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "My RDS Subnet Group"
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "xxx-ecs-cluster"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "my-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "my-container"
      image = "248189943700.dkr.ecr.eu-west-1.amazonaws.com/my-repo:latest"
      memory = 512
      cpu    = 256
      environment = [
        {
          name  = "DATABASE_URL"
          value = "mysql://${jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]}:${jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]}@${aws_db_instance.rds.address}:3306/mydb"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "xxx-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]      #[aws_subnet.ecs_subnet.id, aws_subnet.ecs_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
