variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "engine" {
  description = "The database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "The instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
  default     = {}
}


variable "db_subnet_ids" {
  description = "Private DB subnet IDs (must be in at least 2 AZs)"
  type        = list(string)
}