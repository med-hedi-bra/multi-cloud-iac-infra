terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/aws/network/aws-SUBNET"
}

include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "vpc" {
  config_path = "../aws-VPC"
}

inputs = {
  vpc_id                  = dependency.vpc.outputs.vpc_id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true   # public subnet
  subnet_name             = "portfolio-public-subnet-1"
}
