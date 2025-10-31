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
}
