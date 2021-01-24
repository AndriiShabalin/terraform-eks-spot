provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "education-vpc"
  cidr                 = "20.101.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnets       = ["20.101.0.0/19", "20.101.32.0/19"]
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

}
