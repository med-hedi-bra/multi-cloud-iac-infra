# Private Subnets
resource "google_compute_subnetwork" "private" {
  count         = length(var.gcp_private_subnets)
  
  name          = "private-subnet-${count.index}"
  ip_cidr_range = element(var.gcp_private_subnets, count.index)
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true # Needed for Google APIs (GCR, GKE, etc.)
}

# Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  region  = var.region 

  network = google_compute_network.main.id
}

# Cloud NAT 
resource "google_compute_router_nat" "nat_config" {
  name   = "nat-config"
  router = google_compute_router.nat_router.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY" # GCP will manage NAT IPs
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private
    content {
      name                    = subnetwork.value.self_link
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}
