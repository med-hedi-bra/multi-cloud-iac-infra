# Private control plane subnets (regional)
resource "google_compute_subnetwork" "private_control_plane" {
  count         = length(var.control_plane_private_subnets)
  
  name          = "${var.gke_cluster_name}-control-plane-${count.index}"
  ip_cidr_range = element(var.control_plane_private_subnets, count.index)
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true  # allows access to Google APIs
}

# Cloud Router 
resource "google_compute_router" "nat_router_control_plane" {
  name    = "${var.gke_cluster_name}-control-plane-nat-router"
  region  = var.region
  network = google_compute_network.main.id
}

# 3. Cloud NAT for private control plane subnets
resource "google_compute_router_nat" "nat_control_plane" {
  name                               = "${var.gke_cluster_name}-control-plane-nat"
  router                             = google_compute_router.nat_router_control_plane.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private_control_plane
    content {
      name                    = subnetwork.value.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]  # NAT all IPs in this subnet
    }
  }
}
