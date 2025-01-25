resource "aws_security_group" "wordpress_rds_sg" {
  name        = "wordpress-rds-sg"
  description = "Security group for RDS to allow access from EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ajusta esto según tu configuración de red o usa un Security Group de EKS
    # Aquí puedes referenciar el grupo de seguridad de EKS o las subredes públicas de tus nodos
    #security_groups = [aws_security_group.eks_sg.id]  # Referencia al grupo de seguridad de EKS
    #security_group_id = aws_eks_cluster.wordpress.vpc_config[0].cluster_security_group_id    
    #security_group_id        = aws_security_group.wordpress_rds_sg.id
    #source_security_group_id = aws_eks_cluster.wordpress.vpc_config[0].cluster_security_group_id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_sg" {
  name        = "eks-sg"
  description = "Security group for EKS nodes"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]  # Aquí puedes restringirlo a la red de VPC, por ejemplo
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-subnet-group"
  subnet_ids = var.private_subnet_ids
  #subnet_ids = ["subnet-0ac761233ce029852", "subnet-028a82898c2ffc968"]  
}

resource "aws_db_instance" "wordpress" {
  identifier           = "wordpress-database-fjgl-v2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro" #"db.t3.small"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "wordpress"
  username             = var.db_username
  password             = var.db_password
  publicly_accessible   = false
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.wordpress_rds_sg.id]  # # Asociando el grupo de seguridad creado

}