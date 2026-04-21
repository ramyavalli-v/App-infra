output "hosted_zone_id" {
  description = "Hosted zone ID"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.this.name_servers
}