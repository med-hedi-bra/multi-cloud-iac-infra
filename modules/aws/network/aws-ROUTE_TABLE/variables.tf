variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created."
  type        = string
  
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the route table."
  type        = string
}

variable "route_table_name" {
  description = "The name tag for the route table."
  type        = string
  default     = "custom-route-table"
}

variable "igw_id" {
  description = "The ID of the Internet Gateway to associate with the route table."
  type        = string
  default     = ""
  
}
