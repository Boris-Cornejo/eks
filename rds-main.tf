terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92"
    }
  }
}

provider "aws" {
  region = var.region
}

# Optionally create a VPC and subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"
  count   = var.create_vpc ? 1 : 0

  name = "mssql-vpc"
  cidr = "10.10.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_availability_zones" "available" {}

locals {
  vpc_id     = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  subnet_ids = var.create_vpc ? module.vpc[0].private_subnets : var.subnet_ids
}

# Optionally create a security group
resource "aws_security_group" "rds" {
  count  = var.create_vpc && length(var.security_group_ids) == 0 ? 1 : 0
  name   = "mssql-rds-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict as needed!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  rds_sg_ids = var.create_vpc && length(var.security_group_ids) == 0 ? [aws_security_group.rds[0].id] : var.security_group_ids
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_identifier

  engine               = "sqlserver-ex"
  engine_version       = "15.00"
  family               = "sqlserver-ex-15.0"
  major_engine_version = "15.00"
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_encrypted = true

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name
  port     = 1433

  multi_az               = false
  vpc_security_group_ids = local.rds_sg_ids
  create_db_subnet_group = true
  subnet_ids             = local.subnet_ids

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval    = 30
  create_monitoring_role = true

  deletion_protection = true

  tags = var.tags
}