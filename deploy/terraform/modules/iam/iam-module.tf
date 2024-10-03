resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-eks-role-${var.regionShortName}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        "Service" = "eks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role-${var.regionShortName}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        "Service": "ec2.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

# resource "aws_iam_role" "eks_role" {
#   name = "${var.cluster_name}-eks-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#       Effect = "Allow"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_policy" {
#   role       = aws_iam_role.eks_role.name
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSServiceRolePolicy"
# }


# output "role_arn" {
#   value = aws_iam_role.eks_role.arn
# }


# resource "aws_iam_policy" "eks_policy" {
#   name        = "my-eks-policy"
#   description = "EKS policy"
#   policy      = file("${path.module}/policy/eks_policy.json")
# }

# //The ${path.module} in Terraform refers to the directory of the module 
# //where it is being called. while ./ refers to the directory where the 
# //module has been called which is the main.tf file in this case.
# resource "aws_iam_policy" "node_policy" {
#   name        = "my-node-policy"
#   description = "Node policy"
#   policy      = file("./modules/iam/policy/node_policy.json")
# }

# resource "aws_iam_role_policy_attachment" "eks_policy" {
#   role       = aws_iam_role.eks_role.name
#   policy_arn = aws_iam_policy.eks_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "node_policy" {
#   role       = aws_iam_role.node_role.name
#   policy_arn = aws_iam_policy.node_policy.arn
# }