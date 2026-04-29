data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-vpc"]
  }
}

data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

data "aws_kms_key" "main" {
  key_id = "alias/${var.cluster_name}-eks"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }

  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["shared"]
  }
}

data "aws_security_group" "eks_node" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-node-sg"]
  }

  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["owned"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# DynamoDB Tables
module "dynamodb_tables" {
  source   = "./modules/dynamodb"
  for_each = var.dynamodb_tables

  name                     = each.key
  billing_mode             = lookup(each.value, "billing_mode", "PAY_PER_REQUEST")
  hash_key                 = lookup(each.value, "hash_key", "id")
  range_key                = lookup(each.value, "range_key", null)
  attributes               = lookup(each.value, "attributes", [{ name = "id", type = "S" }])
  global_secondary_indexes = lookup(each.value, "global_secondary_indexes", [])

  tags = var.tags
}

# RDS PostgreSQL Module
module "rds_postgres" {
  source = "./modules/rds-postgres"

  db_name                         = "${var.cluster_name}-postgres"
  vpc_id                          = data.aws_vpc.main.id
  vpc_cidr                        = data.aws_vpc.main.cidr_block
  subnet_ids                      = data.aws_subnets.private.ids
  allowed_security_group_ids      = [data.aws_security_group.eks_node.id]
  kms_key_id                      = data.aws_kms_key.main.arn
  database_name                   = var.rds_database_name
  master_username                 = var.rds_master_username
  master_password                 = var.rds_master_password
  engine_version                  = var.rds_engine_version
  instance_class                  = var.rds_instance_class
  allocated_storage               = var.rds_allocated_storage
  max_allocated_storage           = var.rds_max_allocated_storage
  storage_type                    = var.rds_storage_type
  availability_zone               = var.rds_availability_zone
  backup_retention_period         = var.rds_backup_retention_period
  maintenance_window              = var.rds_maintenance_window
  skip_final_snapshot             = var.rds_skip_final_snapshot
  deletion_protection             = var.rds_deletion_protection
  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports
  tags                            = var.tags
}