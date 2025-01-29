provider "aws" {
  region = "eu-west-1"
}

# Incluye el VPC, Subnets y Security Groups aquí, similar al ejemplo anterior.

module "network" {
  source = "./network" # Incluye un módulo si tienes la configuración de red separada.
}

# Importa los recursos creados en ssm-secret.tf
module "ssm_secret" {
  source = "./conf_ecs"
}
