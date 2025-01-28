module "ecr" {
  source        = "./modules_ecr"
  #repository_name = "app-ecr-repo"
  account_id     = "248189943700"
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
