terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/modules/aws/compute/aws-EC2"
}

include "backend" {
  path = "${find_in_parent_folders("backend.hcl")}"
}

dependency "subnet" {
  config_path = "../aws-SUBNET"
}

dependency "security_group" {
  config_path = "../aws-SECURITY_GROUP"
}

inputs = {
  ami = "ami-0cac988c73f3f939c" #Almalinux 9 in eu-west-3
  instance_type = "t2.micro"
  subnet_id = dependency.subnet.outputs.subnet_id
  security_group_ids = [dependency.security_group.outputs.security_group_id]
  associate_public_ip = true
  key_name = ""
  instance_name = "portfolio"
  volume_size = 16
  volume_type = "gp3"
  volume_delete_on_termination = true
  enable_user_data = true
}
