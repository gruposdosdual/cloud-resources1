module "vpc"{
    source = "terraform-aws-modules/vpc/aws"

    name = "vpc-jgl"
    cidr = "10.0.0.0/16"

    azs = ["eu-west-3a","eu-west-3b", "eu-west-3c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

    create_igw = true
    enable_nat_gateway = true
    single_nat_gateway = false

  # Configuración de las subredes públicas para asociar IP pública
    map_public_ip_on_launch = true

    tags = {
        Terraform = "true"
        Environmet = "feature/add-resources"
    }

    /*
    lifecycle {
    create_before_destroy = true    
  }
  */
}
