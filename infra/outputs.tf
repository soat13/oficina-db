# RDS Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds_postgres.db_instance_endpoint
}

output "rds_address" {
  description = "RDS instance address"
  value       = module.rds_postgres.db_instance_address
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds_postgres.db_instance_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds_postgres.db_instance_name
}
