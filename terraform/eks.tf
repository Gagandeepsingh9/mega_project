module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"
  name               = "eks-shopapp-cluster"
  kubernetes_version = "1.32"

  endpoint_public_access = true
  endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    shopapp-eks-nodes = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]
      min_size     = 1
      max_size     = 2
      desired_size = 2
         }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  

  tags = {
    Environment = var.my_env
    Terraform   = "true"
  }
}

