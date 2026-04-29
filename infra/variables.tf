variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "fiap-eks-cluster"
}

# RDS PostgreSQL Variables
variable "rds_database_name" {
  description = "Name of the default database to create"
  type        = string
  default     = "oficina"
}

variable "rds_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "rds_master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9!#$%&()*+,\\-.:;<=>?\\[\\]^_{|}~]+$", var.rds_master_password))
    error_message = "The password contains invalid characters. Only printable ASCII characters except '/', '@', '\"', and spaces are allowed."
  }

  validation {
    condition     = length(var.rds_master_password) >= 8
    error_message = "The password must be at least 8 characters long."
  }
}

variable "rds_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.6"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling (0 to disable)"
  type        = number
  default     = 100
}

variable "rds_storage_type" {
  description = "Storage type (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "rds_availability_zone" {
  description = "Availability zone for the RDS instance (single AZ deployment). If null, uses first available AZ"
  type        = string
  default     = null
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 5
}

variable "rds_maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "mon:04:00-mon:05:00"
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when deleting"
  type        = bool
  default     = false
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["postgresql"]
}

variable "dynamodb_tables" {
  description = "Map of DynamoDB tables to create"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "fiap-soat"
  }
}

