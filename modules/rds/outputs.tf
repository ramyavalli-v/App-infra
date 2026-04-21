output "db_instance_id" {
  description = "The instance identifier"
  value       = aws_db_instance.this.id
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}