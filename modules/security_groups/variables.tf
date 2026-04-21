variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ingress_rules" {
  description = "Ingress rules"
  type = map(object({
    description                  = string
    protocol                     = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    referenced_security_group_id = optional(string)
    prefix_list_id               = optional(string)
  }))
  default = {}
}


variable "egress_rules" {
  description = "Egress rules for the security group"
  type = map(object({
    description        = string
    protocol           = string
    from_port          = optional(number)
    to_port            = optional(number)
    cidr_ipv4          = optional(string)
    cidr_ipv6          = optional(string)
    referenced_security_group_id  = optional(string)
  }))
}


variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}