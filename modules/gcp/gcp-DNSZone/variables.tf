variable "gcp_project" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

variable "environment_dns_domain" {
  type        = string
  description = "The DNS domain name for the environment (e.g. dev.example.com)"
}

variable "parent_dns_zone_name" {
  type        = string
  description = "The parent DNS zone name (if delegating)"
  default     = ""
}
