variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for Public Subnet 1"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for Public Subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "Availability Zone for Subnet 1"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability Zone for Subnet 2"
  type        = string
}
