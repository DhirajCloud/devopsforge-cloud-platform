module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.project_name}-${var.environment}-eks"
  kubernetes_version = "1.33"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids


  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    kube-proxy = {
      most_recent = true
    }

    coredns = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    default = {
      name = "${var.project_name}-${var.environment}-nodes"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 2

      subnet_ids = var.private_subnet_ids
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
