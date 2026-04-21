variable "name" {
  description = "Name of the ASG"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the launch template"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the ASG"
  type        = map(string)
  default     = {}
}