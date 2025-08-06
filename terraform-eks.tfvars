cluster_name = "my-eks-cluster"
kubernetes_version = "1.31"
vpc_id = "vpc-12345678"
private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
cluster_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
node_group_role_arn = "arn:aws:iam::123456789012:role/eks-node-group-role"
ami_id = "ami-12345678"
tags = {
  Environment = "dev"
  Project     = "my-eks-project"
  Owner       = "your-name"
  ManagedBy   = "terraform"
}
    