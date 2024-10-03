
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.serviceName}-vpc"
  }
}

# The cidrsubnet function in Terraform is used to divide a larger network 
# CIDR block into smaller subnet CIDR blocks. The function takes three arguments: 
# the original CIDR block like /16, the new bit mask like 8 which make it /24, and the subnet number.
# the count.index will be 0 and 1 for the two subnets like 10.0 and 10.1.
resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.serviceName}-private-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+2)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true # Auto-assign public IPs

  tags = {
    Name = "${var.serviceName}-public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.serviceName}-eks-igw"
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
    Name = "${var.serviceName}-eks-public-route-table"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_route_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  
}


resource "aws_eip" "nat" {

  tags = {
    Name = "${var.serviceName}-eks-nat-eip"
  }
  
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.serviceName}-eks-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}

resource "aws_route_table_association" "private_route_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}
