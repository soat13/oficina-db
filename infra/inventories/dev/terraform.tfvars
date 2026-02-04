aws_region = "us-east-1"

cluster_name = "fiap-eks-cluster-dev"

# RDS PostgreSQL Configuration
rds_database_name = "oficina"

# rds_master_username = "postgres"

# rds_master_password = "ChangeMe123!"

rds_engine_version = "16.10"

rds_instance_class = "db.t3.micro"

rds_allocated_storage = 20

rds_max_allocated_storage = 100

rds_storage_type = "gp3"

rds_availability_zone = "us-east-1a"

rds_maintenance_window = "mon:04:00-mon:05:00"

rds_skip_final_snapshot = false

rds_deletion_protection = false

rds_enabled_cloudwatch_logs_exports = ["postgresql"]

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "oficina"
}
