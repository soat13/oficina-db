aws_region = "us-east-1"

cluster_name = "fiap-eks-cluster-prod"

# RDS PostgreSQL Configuration
rds_database_name = "oficina"

# rds_master_username = "postgres"

# rds_master_password = "ChangeMe123!"

rds_engine_version = "17.6"

rds_instance_class = "db.t3.micro"

rds_allocated_storage = 20

rds_max_allocated_storage = 100

rds_storage_type = "gp3"

rds_availability_zone = "us-east-1a"

rds_maintenance_window = "mon:04:00-mon:05:00"

rds_skip_final_snapshot = false

rds_deletion_protection = false

rds_enabled_cloudwatch_logs_exports = ["postgresql"]

# DynamoDB Tables
dynamodb_tables = {
  "users" = {
    hash_key = "id"
    attributes = [
      { name = "id", type = "S" },
      { name = "document", type = "S" },
      { name = "email", type = "S" }
    ]
    global_secondary_indexes = [
      {
        name            = "document-index"
        hash_key        = "document"
        projection_type = "ALL"
      },
      {
        name            = "email-index"
        hash_key        = "email"
        projection_type = "ALL"
      }
    ]
  }
  "payments" = {
    hash_key  = "pk"
    range_key = "sk"
    attributes = [
      { name = "pk", type = "S" },
      { name = "sk", type = "S" },
      { name = "gsi1pk", type = "S" },
      { name = "gsi1sk", type = "S" }
    ]
    global_secondary_indexes = [
      {
        name            = "gsi1"
        hash_key        = "gsi1pk"
        range_key       = "gsi1sk"
        projection_type = "ALL"
      }
    ]
  }
}

tags = {
  Environment = "prod"
  ManagedBy   = "terraform"
  Project     = "oficina"
}