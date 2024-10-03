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

variable "serviceName" {
  type = string
}