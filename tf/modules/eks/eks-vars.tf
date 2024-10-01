# AWS Region
variable "aws_region" {
  default = "us-east-1"
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


variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS control plane"
  type        = list(string)
}


