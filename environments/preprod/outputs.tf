output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "domain_name" {
  description = "Domain name for the application"
  value       = var.domain_name
}

output "instance_type" {
  description = "EC2 instance type"
  value       = var.instance_type
}

output "db_subnet_group_name" {
  description = "Database subnet group name"
  value       = var.db_subnet_group_name
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.alb_arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = module.rds.db_instance_id
}