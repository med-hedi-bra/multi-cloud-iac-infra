resource "google_service_account" "gke_nodes" {
  account_id   = "${google_container_cluster.products_cluster.name}-sa"
  display_name = "GKE Node Service Account"
  project      = var.gcp_project
}

# Google Service Account for Workload Identity 
resource "google_service_account" "workload_identity_sa" {
  account_id   = "${google_container_cluster.products_cluster.name}-wl-sa"
  display_name = "Workload Identity Service Account for ${google_container_cluster.products_cluster.name}"
  project      = var.gcp_project
}

# IAM binding to allow Kubernetes Service Account to impersonate Google Service Account
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.workload_identity_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[kube-system/gcp-node]",
  ]
}

# Grant the service account specific permissions
resource "google_project_iam_member" "workload_identity_sa_permissions" {
  for_each = toset([
    "roles/container.nodeServiceAccount",      
    "roles/storage.objectViewer",              
  ])  
  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.workload_identity_sa.email}"
}


# Assign IAM roles to the node service account
resource "google_project_iam_member" "gke_nodes_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",      
    "roles/storage.objectViewer",              
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Node Pool for the cluster
resource "google_container_node_pool" "products_node_pool" {
  name       = "products-node-pool"
  cluster    = google_container_cluster.products_cluster.name
  location   = var.region

  node_count = var.gke_node_group_desired_size
  node_config {
    machine_type = var.instance_type
    service_account = google_service_account.gke_nodes.email

    # Enable Workload Identity on nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    # Security configuration
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    disk_size_gb = 50
    disk_type    = "pd-standard"  
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    tags = ["gke-node"]
  }

  autoscaling {
    min_node_count = var.gke_node_group_min_size
    max_node_count = var.gke_node_group_max_size
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  depends_on = [
    google_container_cluster.products_cluster,
    google_project_iam_member.workload_identity_sa_permissions,
  ]
}

