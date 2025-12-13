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

# Create DNS Managed Zone for the environment
resource "google_dns_managed_zone" "environment_zone" {
  name        = replace(var.environment_dns_domain, ".", "-") 
  dns_name    = "${var.environment_dns_domain}."
  description = "DNS zone for ${var.environment_dns_domain}"
}

# Optionally look up parent zone
data "google_dns_managed_zone" "parent_zone" {
  count = var.parent_dns_zone_name != "" ? 1 : 0
  name  = replace(var.parent_dns_zone_name, ".", "-")
}

# Create NS record in parent zone (if provided)
resource "google_dns_record_set" "parent_zone" {
  count   = var.parent_dns_zone_name != "" ? 1 : 0
  name    = "${var.environment_dns_domain}."
  type    = "NS"
  ttl     = 30
  managed_zone = data.google_dns_managed_zone.parent_zone[0].name
  rrdatas = google_dns_managed_zone.environment_zone.name_servers
}
