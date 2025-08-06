variable "cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
}

variable "task_family" {
  type        = string
  description = "Name of the ECS Task Definition family"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL of the ECR repository"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role ARN for ECS task execution"
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for the ECS task"
}

variable "target_group_arn" {
  type        = string
  description = "Target Group ARN for ALB"
}

variable "listener_arn" {
  type        = string
  description = "Listener ARN for ALB (used in depends_on)"
}
