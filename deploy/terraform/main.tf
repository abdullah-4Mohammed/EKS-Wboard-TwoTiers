//when you call a module in Terraform, everything listed other than 
//the source are variables for that module "left side var name". These variables are essentially 
//arguments values that you're passing into the module.
//you need to define these vars in the module's vars.tf file.

# provider "aws" {
#   region = "us-east-1"
# }

module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  serviceName        = var.serviceName
  region             = var.region
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
  serviceName = var.serviceName
  region = var.region
  vpc_cidr = var.vpc_cidr
  regionShortName = var.regionShortName
  availability_zones = var.availability_zones
}


module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  eks_role_arn     = module.iam.eks_role_arn  # Pass the role_arn from IAM module
  node_role_arn    = module.iam.node_role_arn # Pass the role_arn from IAM module
  public_subnet_ids   = module.network.public_subnet_ids  # Pass the subnet_ids from the network module
  private_subnet_ids  = module.network.private_subnet_ids # Pass the subnet_ids from the network module
  vpc_id              = module.network.vpc_id             # Pass the vpc_id from the network module
  vpc_cidr      = var.vpc_cidr     # Pass the vpc_cidr_block from the network module
  serviceName = var.serviceName
  region = var.region

}







////
# module "eks" {
#   source = "terraform-aws-modules/eks/aws"
#   version = "19.15.1"
#   cluster_name = "wboard-eks"
#   cluster_version = "1.26"
#   cluster_endpoint_public_access = true #The API server pulic. manage the cluster using kubectl from anywhere.
#   //false: The API server endpoint will only be accessible from within the VPC.
#   // This enhances security but requires you to be within the VPC or use a VPN/other access method to manage the cluster.//
#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets
#   //the subnets where the EKS control plane (the management layer of Kubernetes) will be deployed.
#   //The control plane runs in an account managed by AWS, and the Kubernetes API is exposed via the Amazon EKS endpoint.
#   //Ensures high availability and fault tolerance for the control plane by spreading it across multiple availability zones.
#   control_plane_subnet_ids = module.vpc.intra_subnets
#   // Essential for internal service communication.
#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     //  Manages network rules on nodes to ensure communication between services. 
#     // It's necessary for routing network traffic efficiently. 
#     kube-proxy = {
#       most_recent = true
#     }
#     //Manages the networking for pods, providing IP addresses to them from the VPC. 
#     //It's crucial for pod networking within AWS.
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   eks_managed_node_group_defaults = {
#     ami_type       = "AL2_x86_64"
#     instance_types = ["t2.micro"]
#     //whether to attach the primary security group associated with the cluster to the node groups.
#     //The primary security group is typically created by the EKS module itself if not provided.
#     attach_cluster_primary_security_group = true
#   }
#   eks_managed_node_groups = {
#     eks_node_group = {
#       min_size     = 1
#       max_size     = 8
#       desired_size = 2
#       capacity_type  = "SPOT"
#     }
#   }

#   tags = {
#     Environment = "test"
#   }
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 5.0"

#   name = "${local.resourceName}-vpc"
#   cidr = local.vpc_cidr

#   azs             = local.azs
#   private_subnets = local.private_subnets
#   public_subnets  = local.public_subnets
#   intra_subnets   = local.intra_subnets

#   enable_nat_gateway = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }