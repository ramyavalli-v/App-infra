locals {
  common_tags = merge(var.common_tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

output "tags" {
  description = "Common tags to be applied to resources"
  value       = local.common_tags
}