# Private data plane subnets (regional)
resource "google_compute_subnetwork" "private_data_plane" {
  count         = length(var.data_plane_private_subnets)

  name          = "${var.gke_cluster_name}-data-plane-${count.index}"
  ip_cidr_range = element(var.data_plane_private_subnets, count.index)
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true  # allows access to Google APIs from private subnet
}

# Cloud Router 
resource "google_compute_router" "nat_router_data_plane" {
  name    = "${var.gke_cluster_name}-data-plane-nat-router"
  region  = var.region
  network = google_compute_network.main.id
}

# 3. Cloud NAT for private data plane subnets
resource "google_compute_router_nat" "nat_data_plane" {
  name                               = "${var.gke_cluster_name}-data-plane-nat"
  router                             = google_compute_router.nat_router_data_plane.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private_data_plane
    content {
      name                    = subnetwork.value.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]  # allow all IPs in subnet to go outbound
    }
  }
}
