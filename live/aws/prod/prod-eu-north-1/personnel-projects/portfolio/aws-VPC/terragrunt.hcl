terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/aws/network/aws-VPC"
}

include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

inputs = {
  cidr_block = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_name     = "portfolio-vpc"
}


