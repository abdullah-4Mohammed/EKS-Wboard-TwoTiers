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

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}


