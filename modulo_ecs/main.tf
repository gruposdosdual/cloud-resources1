provider "aws" {
  region  = "eu-west-1"
  profile = "248189943700_EKS-alumnos"
}

# P default VPC
resource "aws_default_vpc" "default_vpc" {
}

# default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "eu-west-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "eu-west-1c"
}

resource "aws_ecr_repository" "mi_primer_ecr_repo" {
  name = "fjgl-ecr-repo"
}

resource "aws_ecs_cluster" "mi_cluster" {
  name = "fjgl-cluster" # Nombra el cluster
}


resource "aws_ecs_task_definition" "mi_primer_task" {
  family                   = "primer-task" # Nombra tu primer task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "mi-primer-task",
      "image": "${aws_ecr_repository.mi_primer_ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] 
  network_mode             = "awsvpc" 
  memory                   = 512       
  cpu                      = 256        
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}



resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRoleUnique"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}



/*
data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}
*/


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ------------------------------
# Crear una política de IAM para permisos de autoescalado y ECS
resource "aws_iam_policy" "ecs_scaling_policy" {
  name        = "ecsScalingPolicy"
  description = "Política para permitir el autoescalado de ECS y otros permisos relacionados"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "application-autoscaling:RegisterScalableTarget",
          "application-autoscaling:PutScalingPolicy",
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]
        Resource = "*"
      }
    ]
  })
}

# Asociar la política creada al rol de ejecución de ECS
resource "aws_iam_role_policy_attachment" "ecs_scaling_policy_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name  # Usa el nombre de tu rol de ejecución
  policy_arn = aws_iam_policy.ecs_scaling_policy.arn
}

# ---------------------------------------------------------------



resource "aws_alb" "application_load_balancer" {
  name               = "test-lb-tf" # testea el load balancer
  load_balancer_type = "application"
  subnets = [ 
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  #  security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Crear security group para el  load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.default_vpc.id}" 
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" 
  }
}

resource "aws_ecs_service" "mi_primer_service" {
  name            = "primer-service"                             
  cluster         = "${aws_ecs_cluster.mi_cluster.id}"             
  task_definition = "${aws_ecs_task_definition.mi_primer_task.arn}" 
  launch_type     = "FARGATE"
  desired_count   = 3 

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" 
    container_name   = "mi-primer-task"  #"${aws_ecs_task_definition.mi_primer_task.family}"
    container_port   = 3000 
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true                                                
    security_groups  = ["${aws_security_group.service_security_group.id}"] 
  }
}


resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

