variable "gcp_project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-north1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "subnetwork" {
  type    = string
  default = "default"
}

variable "k8s_version" {
  type    = string
  default = "1.32"
}

variable "instance_type" {
  type    = string
  default = "e2-medium"
}

variable "node_pool_desired_size" {
  type    = number
  default = 2
}

variable "node_pool_min_size" {
  type    = number
  default = 1
}

variable "node_pool_max_size" {
  type    = number
  default = 3
}

variable "control_plane_subnet_ids" {
  description = "control plane subnet IDs"
  type        = list(string)
}

variable "data_plane_subnet_ids" {
  description = "data plane subnet IDs"
  type        = list(string)
}

variable "gke_node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 3
}

variable "gke_node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 3 
}

variable "gke_node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 50
}