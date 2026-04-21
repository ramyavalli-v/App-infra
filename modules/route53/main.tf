resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = var.tags
}

resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", 300)
  records = each.value.records
}