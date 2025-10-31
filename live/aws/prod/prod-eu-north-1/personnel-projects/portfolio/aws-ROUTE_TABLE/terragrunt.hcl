terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/aws/network/aws-ROUTE_TABLE"
}

include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "vpc" {
  config_path = "../aws-VPC"
}

dependency "subnet" {
  config_path = "../aws-SUBNET"
}

inputs = {
  vpc_id   = dependency.vpc.outputs.vpc_id
  subnet_id = dependency.subnet.outputs.subnet_id
  route_table_name     = "portfolio-public-rt"
  igw_id   = dependency.vpc.outputs.igw_id
  
}
