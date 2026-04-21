variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "preprod"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "myc3ops.com"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "db_subnet_group_name" {
  description = "Database subnet group name"
  type        = string
  default     = "c3ops_preprod-preprod-private-db-ap-south-1b"
}
variable "web_subnet_group_name" {
  description = "web subnet group name"
  type        = string
  default     = "c3ops_preprod-preprod-private-web-ap-south-1b"
}

variable "app_subnet_group_name" {
  description = "app subnet group name"
  type        = string
  default     = "c3ops_preprod-preprod-private-app-ap-south-1b"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project = "AppInfra"
    Owner   = "DevOps"
  }
}