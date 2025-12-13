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

# Enable Compute Engine API, Kubernetes Engine API, Cloud Resource Manager API
resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])

  project            = var.gcp_project
  service            = each.value
  disable_on_destroy = false
}


