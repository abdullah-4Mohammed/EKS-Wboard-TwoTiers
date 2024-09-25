resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = module.iam.role_arn

  vpc_config {
    subnet_ids = module.network.subnet_ids
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = module.iam.role_arn
  subnet_ids      = module.network.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}
