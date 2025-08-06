terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  addons = {
    coredns                = {}
    eks-pod-identity-agent = { before_compute = true }
    kube-proxy             = {}
    vpc-cni                = { before_compute = true }
  }

  # Make the cluster private
  endpoint_private_access = true
  endpoint_public_access  = false

  # Use your existing VPC and subnets
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  # Use your existing IAM roles
  create_iam_role    = false
  iam_role_arn       = var.cluster_role_arn
  create_node_iam_role = false

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default = {
      ami_id        = var.ami_id
      instance_types = ["t3.medium"] # Change as needed
      min_size      = 2
      max_size      = 5
      desired_size  = 2
      iam_role_arn  = var.node_group_role_arn
      subnet_ids    = var.private_subnet_ids
    }
  }

  tags = var.tags
}