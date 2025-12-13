terraform {
  required_version = "= 1.5.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.region
}

# Enable necessary APIs
resource "google_project_service" "cloud_sql_admin" {
  project = var.gcp_project
  service = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "servicenetworking" {
  project = var.gcp_project
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}


data "google_client_config" "default" {}

data "google_container_cluster" "products_cluster" {
  name     = var.gke_cluster_name
  location = var.region
}

provider "kubernetes" {
  host                   = data.google_container_cluster.products_cluster.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.products_cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}



# Random password for database if not provided
resource "random_password" "db_password" {
  count   = var.master_password == "" ? 1 : 0
  length  = 16
  special = true
}

locals {
  db_password = var.master_password != "" ? var.master_password : random_password.db_password[0].result
  pg_port     = "5432"
}


resource "google_compute_global_address" "cloudsql_private_range" {
  name          = "cloudsql-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = split("/", var.database_private_ip_cidr_range)[0]
  prefix_length = tonumber(split("/", var.database_private_ip_cidr_range)[1])
  network       = var.vpc_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_range.name]
}


# Cloud SQL instance with high availability
resource "google_sql_database_instance" "main" {
  name             = "products-pg-instance"
  database_version = "POSTGRES_${replace(var.engine_version_pg, ".", "_")}"
  region           = var.region
  deletion_protection = var.deletion_protection

  settings {
    tier                        = var.instance_class
    availability_type           = "REGIONAL"
    disk_type                   = "PD_SSD"
    disk_size                   = var.disk_size_gb
    disk_autoresize             = true
    disk_autoresize_limit       = var.max_disk_size_gb

    backup_configuration {
      enabled                        = true
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = var.backup_retention_period
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                              = var.vpc_id
      enable_private_path_for_google_cloud_services = true
    }

    database_flags {
      name  = "log_statement"
      value = "all"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "1000"
    }

    # insights_config {
    #   query_insights_enabled  = true
    #   query_string_length     = 1024
    #   record_application_tags = true
    #   record_client_address   = true
    # }

    # maintenance_window {
    #   day          = 7
    #   hour         = 3
    #   update_track = "stable"
    # }

    user_labels = var.default_labels
  }
  root_password = local.db_password
  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    ]
}

# Create database user
resource "google_sql_user" "main" {
  name     = var.master_username
  instance = google_sql_database_instance.main.name
  password = local.db_password
}


# Create Kubernetes secret with connection details
resource "kubernetes_secret_v1" "pg_credentials" {
  metadata {
    name      = var.pg_credentials_name
    namespace = var.pg_credentials_namespace
  }

  data = {
    "connection.postgres.authentication.username"        = var.master_username
    "connection.postgres.authentication.password"        = local.db_password
    "connection.postgres.certificate.certificate_base64" = base64encode(google_sql_database_instance.main.server_ca_cert[0].cert)
    "connection.postgres.hosts.0.hostname"               = google_sql_database_instance.main.private_ip_address
    "connection.postgres.hosts.0.port"                   = local.pg_port
  }

  depends_on = [
    google_sql_database_instance.main,
    google_sql_user.main,
  ]
}