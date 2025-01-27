provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  alb_security_group = module.alb.alb_security_group
  target_group_nginx = module.alb.target_group_nginx
  target_group_flask = module.alb.target_group_flask
}