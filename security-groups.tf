resource "aws_security_group" "allow_ssh_from_vpc" {
  name_prefix = "allow_ssh_from_eks_vpc"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "20.131.0.0/16",
    ]
  }
}
