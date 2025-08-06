variable "name" {
  description = "Base name for ALB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}


variable "security_group_id" {
  description = "Security group for the ALB"
  type        = string
}
