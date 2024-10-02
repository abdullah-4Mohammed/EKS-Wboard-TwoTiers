# AWS Region
variable "aws_region" {
  default = "eu-west-2"
}

# VPC (network module) variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b"]
}

# EKS (eks module) variables
variable "cluster_name" {
  default = "my-eks-cluster"
}




