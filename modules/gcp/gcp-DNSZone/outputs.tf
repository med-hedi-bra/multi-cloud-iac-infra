output "dns_zone_id" {
  value = google_dns_managed_zone.environment_zone.id
}

output "dns_zone_name" {
  value = google_dns_managed_zone.environment_zone.dns_name
}
