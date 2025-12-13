resource "google_compute_subnetwork" "public" {
  count         = length(var.public_subnets)
  
  name          = "${var.gke_cluster_name}-public-${count.index}"
  ip_cidr_range = element(var.public_subnets, count.index)
  region        = var.region
  network       = google_compute_network.main.id
  private_ip_google_access = true
}
