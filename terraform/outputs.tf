# Network Module Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id_1" {
  value = module.network.public_subnet_id_1
}

output "public_subnet_id_2" {
  value = module.network.public_subnet_id_2
}

# Security Group Outputs
output "alb_sg_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = module.security.alb_sg_id
}

output "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  value       = module.security.ecs_sg_id
}

# ECR Output
output "ecr_repository_url" {
  description = "URL of the created ECR repository"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
