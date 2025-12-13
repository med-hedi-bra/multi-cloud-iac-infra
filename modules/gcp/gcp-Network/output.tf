output "vpc_id" {
  value       = google_compute_network.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = google_compute_subnetwork.public[*].id
  description = "The IDs of the public subnets"
}

output "private_gcp_subnet_ids" {
  value       = google_compute_subnetwork.private[*].id
  description = "The IDs of the private subnets"
}


output "private_control_plane_subnet_ids" {
  value       = google_compute_subnetwork.private_control_plane[*].id
  description = "The IDs of the private subnets for control plane"
}

output "private_data_plane_subnet_ids" {
  value       = google_compute_subnetwork.private_data_plane[*].id
  description = "The IDs of the private subnets for data plane"
}

output "nat_router_control_plane_name" {
  value       = google_compute_router_nat.nat_control_plane.name
  description = "The name of the NAT for private control plane subnets"
}

output "nat_router_data_plane_name" {
  value       = google_compute_router_nat.nat_data_plane.name # NAT in GCP doesn’t have a single public IP unless you explicitly allocate one
  description = "The name of the NAT for private data plane subnets"
}
