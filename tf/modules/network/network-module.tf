
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "eks-vpc"
  }
}

# The cidrsubnet function in Terraform is used to divide a larger network 
# CIDR block into smaller subnet CIDR blocks. The function takes three arguments: 
# the original CIDR block like /16, the new bit mask like /24, and the subnet number.
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

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 24, count.index)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true # Auto-assign public IPs

  tags = {
    Name = "eks-public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "eks-igw"
  }
}

# Public Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "eks-public-route-table"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_route_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}




output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
