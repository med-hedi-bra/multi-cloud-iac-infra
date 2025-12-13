locals {
  cluster_name = "products-cluster"
}

resource "google_container_cluster" "products_cluster" {
  name     = local.cluster_name
  location = var.region       

  # Kubernetes version
  initial_node_count = 1
  min_master_version = var.k8s_version

  # Enable Workload Identity on the cluster
  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }
  
  # Networking
  network    = var.vpc_id
  subnetwork = var.control_plane_subnet_ids[0]  # GKE cluster uses one subnet per cluster
  addons_config {
    network_policy_config {
      disabled = false
    }
  }
  # Enable Kubernetes Network Policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # Private cluster 
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false   
  }

  # Public endpoint
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Logging & Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # IAM / Service account for cluster control plane
  remove_default_node_pool = true

  deletion_protection = false
}
