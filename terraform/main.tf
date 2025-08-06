provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr_1 = var.public_subnet_cidr_1
  public_subnet_cidr_2 = var.public_subnet_cidr_2
  availability_zone_1  = var.availability_zone_1
  availability_zone_2  = var.availability_zone_2
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "2048-game-repo"
}

module "iam" {
  source = "./modules/iam"
}

module "alb" {
  source            = "./modules/alb"
  name              = "2048-game-alb"
  vpc_id            = module.network.vpc_id
  subnet_ids        = [module.network.public_subnet_id_1, module.network.public_subnet_id_2]
  security_group_id = module.security.alb_sg_id
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "2048-game-cluster"
  task_family        = "2048-task"
  ecr_repository_url = module.ecr.repository_url
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  subnet_ids         = [module.network.public_subnet_id_1, module.network.public_subnet_id_2]
  security_group_id  = module.security.ecs_sg_id
  target_group_arn   = module.alb.target_group_arn
  listener_arn       = module.alb.listener_arn
}
