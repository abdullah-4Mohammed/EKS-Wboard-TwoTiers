# AWS Region
variable "aws_region" {
  default = "us-east-1"
}

# VPC (network module) variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

# EKS (eks module) variables
variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}
