variable "domain_name" {
  description = "Domain name for Route53 hosted zone"
  type        = string
}

variable "records" {
  description = "Route53 records"
  type = map(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags for the hosted zone"
  type        = map(string)
  default     = {}
}