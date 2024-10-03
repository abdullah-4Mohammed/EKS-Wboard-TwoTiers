# AWS Region
variable "region" {
  type = string
}

# VPC (network module) variables
variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

# EKS (eks module) variables
variable "cluster_name" {
  type = string
}

variable "serviceName" {
  type = string
}

variable "regionShortName" {
  type = string
}


