# AWS Region
variable "region" {
  default = "eu-west-2"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "eks_role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS control plane"
  type        = list(string)
}


