locals {
  cluster_name = "eks-spot-${random_string.suffix.result}"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.public_subnets

  tags = {
    Environment = "dev"
  }

  vpc_id = module.vpc.vpc_id



  worker_groups_launch_template = [
    {
      name                          = "spot-1"
      override_instance_types       = ["t3.small", "t4g.small", "t3a.small", "t2.small"]
      root_volume_size              = 30
      spot_instance_pools           = 1
      asg_max_size                  = 3
      asg_desired_capacity          = 2
      public_ip                     = true
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/lifecycle=spot"
      additional_security_group_ids = [aws_security_group.allow_ssh_from_vpc.id]
    },

    {
      name                          = "spot-2"
      override_instance_types       = ["t3.small", "t4g.small", "t3a.small", "t2.small"]
      root_volume_size              = 30
      spot_instance_pools           = 1
      asg_max_size                  = 3
      asg_desired_capacity          = 2
      public_ip                     = true
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/lifecycle=spot"
      additional_security_group_ids = [aws_security_group.allow_ssh_from_vpc.id]
    },
  ]

  worker_groups = [
    {
      name                          = "on-demand-1"
      instance_type                 = "t2.micro"
      root_volume_size              = 30
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      asg_max_size                  = 2
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/lifecycle=normal"
      additional_security_group_ids = [aws_security_group.allow_ssh_from_vpc.id]
    },
    {
      name                          = "on-demand-2"
      instance_type                 = "t2.micro"
      root_volume_size              = 30
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      asg_max_size                  = 2
      kubelet_extra_args            = "--node-labels=node.kubernetes.io/lifecycle=normal"
      additional_security_group_ids = [aws_security_group.allow_ssh_from_vpc.id]
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
