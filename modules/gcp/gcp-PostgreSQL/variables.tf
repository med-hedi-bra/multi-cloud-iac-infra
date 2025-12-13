variable "default_labels" {
  type        = map(string)
  description = "Default labels for all resources"
  default = {
    managed_by = "terraform"
  }
}

variable "gcp_project" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

variable "vpc_id" {
  description = "VPC network self-link or name"
  type        = string
}


variable "engine_version_pg" {
  description = "PostgreSQL engine version (e.g., '15')"
  type        = string
  default     = "15"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "product_admin"
}

variable "master_password" {
  description = "Master password for the database (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Number of backup copies to retain"
  type        = number
  default     = 14
}

variable "backup_start_time" {
  description = "Backup start time in UTC (HH:MM format)"
  type        = string
  default     = "03:00"
}

variable "instance_count" {
  description = "Number of database instances (1 for single instance, >1 for high availability with replicas)"
  type        = number
  default     = 2
}

variable "instance_class" {
  type        = string
  description = "Machine type for the Cloud SQL instance"
  default     = "db-custom-4-16384" 
}

variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB"
  default     = 100
}

variable "max_disk_size_gb" {
  type        = number
  description = "Maximum disk size for autoresize in GB"
  default     = 500
}

variable "database_name" {
  type        = string
  description = "Name of the initial database to create"
  default     = "products"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the Cloud SQL instance"
  default     = true
}

variable "gke_cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "pg_credentials_namespace" {
  description = "Namespace where the PostgreSQL credentials secret is deployed"
  type        = string
}

variable "pg_credentials_name" {
  description = "Name of the PostgreSQL credentials secret"
  type        = string
}

variable "database_private_ip_cidr_range" {
  description = "The private IP CIDR range for the Cloud SQL instance"
  type        = string
  
}