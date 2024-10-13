resource "aws_security_group" "lb_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic
  }

  tags = {
    Name = "LoadBalancer Security Group"
  }
}




# Security Group for EKS Cluster (control plane)
resource "aws_security_group" "eks_cluster_sg" {
  vpc_id = var.vpc_id

  # Allow traffic between nodes in the cluster
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks =  [var.vpc_cidr] # Allow traffic from within the VPC
  }

  # Allow Kubernetes API access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # Allow traffic from within the VPC
  }

  # Allow SSH access (optional, change as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP or range for security
  }

  # Tags for the security group
  tags = {
    Name = "${var.cluster_name}-eks-sg"
  }
}

# Security Group for EKS Node Group
resource "aws_security_group" "eks_node_sg" {
  vpc_id = var.vpc_id

  # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow traffic between nodes in the cluster
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id] # Allow traffic from the cluster security group
  }

  # Allow traffic to the internet (if using public subnets)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for the security group
  tags = {
    Name = "${var.cluster_name}-eks-node-sg"
  }
}





resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id] # Attach the control plane security group
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"

  # depends_on = [
  #   aws_iam_role_policy_attachment.node_worker_policy,
  #   aws_iam_role_policy_attachment.node_cni_policy,
  #   aws_iam_role_policy_attachment.ecr_read_only_policy,
  # ]

}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}
