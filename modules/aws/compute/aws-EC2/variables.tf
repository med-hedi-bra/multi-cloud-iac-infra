variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "key_name" {
  type    = string
  default = ""
}

variable "instance_name" {
  type    = string
  default = "public-ec2"
}


variable "volume_size" {
  type    = number
  default = 8
  
}

variable "volume_type" {
  type    = string
  default = "gp2"
  
}

variable "volume_delete_on_termination" {
  type    = bool
  default = true
  
}

variable "enable_user_data" {
  type    = bool
  default = false
  
}
