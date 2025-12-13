output "pg_credentials_secret_name" {
  description = "Name of the PostgreSQL credentials secret"
  value       = kubernetes_secret_v1.pg_credentials.metadata[0].name
}

output "pg_credentials_secret_namespace" {
  description = "Namespace where the PostgreSQL credentials secret is deployed"
  value       = kubernetes_secret_v1.pg_credentials.metadata[0].namespace
}

output "database_instance_name" {
  description = "Name of the Cloud SQL database instance"
  value       = google_sql_database_instance.main.name
}

output "database_connection_name" {
  description = "Connection name for the Cloud SQL instance"
  value       = google_sql_database_instance.main.connection_name
}

output "database_private_ip" {
  description = "Private IP address of the database instance"
  value       = google_sql_database_instance.main.private_ip_address
}

output "database_public_ip" {
  description = "Public IP address of the database instance"
  value       = google_sql_database_instance.main.public_ip_address
}


output "master_username" {
  description = "Master username for the database"
  value       = google_sql_user.main.name
}
