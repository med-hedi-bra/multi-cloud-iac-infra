output "gke_cluster_name" {
  value = google_container_cluster.products_cluster.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.products_cluster.endpoint
}

output "gke_cluster_ca_certificate" {
  value = google_container_cluster.products_cluster.master_auth[0].cluster_ca_certificate
}
