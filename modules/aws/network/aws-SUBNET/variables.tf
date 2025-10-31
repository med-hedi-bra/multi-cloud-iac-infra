variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "A boolean flag to indicate whether to assign a public IP address to instances launched in this subnet."
  type        = bool
  default     = false
}
variable "subnet_name" {
  description = "The name tag for the subnet."
  type        = string
  default     = "custom-subnet"
}