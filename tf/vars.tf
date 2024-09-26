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




# variable "environment" {
#   type = string
# }

# variable "serviceShortName" {
#   type = string
# }

# variable "regionShortName" {
#   type = string
# }

# variable "backendBucket" {
#   type = string
# }
# // this test
# variable "region" {
#   type = string
# }

# locals {
#   resourceName = "Az-aws-${var.serviceShortName}-${var.environment}-${var.regionShortName}"
#   key = "tf/${var.environment}.tfstate"
#   region = "${var.region}"
#   backendBucket = "${var.backendBucket}"

#   vpc_cidr = "10.10.0.0/16"
#   azs      = ["${var.region}a", "${var.region}b"]

#   public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
#   private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
#   intra_subnets   = ["10.10.5.0/24", "10.10.6.0/24"]
# }
