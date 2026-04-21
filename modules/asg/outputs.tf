output "asg_name" {
  description = "Name of the ASG"
  value       = aws_autoscaling_group.this.name
}

output "asg_arn" {
  description = "ARN of the ASG"
  value       = aws_autoscaling_group.this.arn
}