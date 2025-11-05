terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/aws/network/aws-SECURITY_GROUP"
}

include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "vpc" {
  config_path = "../aws-VPC"
}

inputs = {
  vpc_id                  = dependency.vpc.outputs.vpc_id
  security_group_name             = "portfolio-public-sg-1"
  ingress_rules          = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules          = [
    {
      description = "Allow all egress traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}