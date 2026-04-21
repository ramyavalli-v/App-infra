variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the bucket"
  type        = map(string)
  default     = {}
}