# AWS Region
variable "region" {
  type = string
}

# VPC (network module) variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)
}

# EKS (eks module) variables
variable "cluster_name" {
  type = string
  
}



variable "environment" {
  type = string
}

variable "serviceName" {
  type = string
}


variable "backendBucket" {
  type = string
}

variable "regionShortName" {
  type = string
}

locals {
  resourceName = "${var.serviceName}-${var.environment}-${var.regionShortName}"
  key = "tf/${var.environment}.tfstate"
  //region = "${var.region}"
  backendBucket = "${var.backendBucket}"
}

#   vpc_cidr = "10.10.0.0/16"
#   azs      = ["${var.region}a", "${var.region}b"]

#   public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
#   private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
#   intra_subnets   = ["10.10.5.0/24", "10.10.6.0/24"]
# }
