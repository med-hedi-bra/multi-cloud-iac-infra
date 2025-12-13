terraform {
  required_version = "= 1.5.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.2.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.region
}

resource "google_project_service" "compute" {
  project = var.gcp_project
  service = "compute.googleapis.com"

  disable_on_destroy = false
}
resource "google_compute_network" "main" {
  name                    = "${var.gke_cluster_name}-vpc"
  auto_create_subnetworks = false
}
