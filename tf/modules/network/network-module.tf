
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "eks-vpc"
  }
}

# The cidrsubnet function in Terraform is used to divide a larger network 
# CIDR block into smaller subnet CIDR blocks. The function takes three arguments: 
# the original CIDR block, the new bit mask, and the subnet number.
resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "eks-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
