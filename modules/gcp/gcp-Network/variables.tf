variable "gcp_project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-north1"
}

variable "gke_cluster_name" {
  type    = string
  default = "products-cluster"
}

variable "public_subnets" {
  type = list(string)
}

variable "control_plane_private_subnets" {
  type = list(string)
}

variable "data_plane_private_subnets" {
  type = list(string)
}

variable "gcp_private_subnets" {
  type = list(string)
}
