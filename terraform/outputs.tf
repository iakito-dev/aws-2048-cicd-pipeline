# Network Module Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.network.public_subnet_id
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
