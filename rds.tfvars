region              = "us-west-2"
create_vpc          = false
vpc_id              = "vpc-xxxxxxxx"
subnet_ids          = ["subnet-aaaaaaa", "subnet-bbbbbbb"]
security_group_ids  = ["sg-xxxxxxxx"]
db_identifier       = "mssql-db"
db_username         = "mssqladmin"
db_password         = "YourStrongPassword123!"
db_name             = "mydb"
tags = {
  Owner       = "yourname"
  Environment = "dev"
}