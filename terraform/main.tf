provider "aws" {
  region = var.aws_region
}

module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone   = var.availability_zone
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "2048-game-repo"
}
