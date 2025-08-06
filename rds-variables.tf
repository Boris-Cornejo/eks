variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "create_vpc" {
  description = "Whether to create a new VPC or use existing"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the existing VPC (if not creating a new one)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS (at least 2 in different AZs)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for RDS"
  type        = list(string)
  default     = []
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "mssql-db"
}

variable "db_username" {
  description = "Master username"
  type        = string
  default     = "mssqladmin"
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}