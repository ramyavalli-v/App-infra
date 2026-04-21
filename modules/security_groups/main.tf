resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags
}


resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = each.value.protocol

  from_port = try(each.value.from_port, null)
  to_port   = try(each.value.to_port, null)

  cidr_ipv4                   = try(each.value.cidr_ipv4, null)
  cidr_ipv6                   = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
  prefix_list_id              = try(each.value.prefix_list_id, null)
}



resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.this.id

  description     = each.value.description
  from_port       = each.value.from_port
  to_port         = each.value.to_port
  ip_protocol     = each.value.protocol
  cidr_ipv4       = try(each.value.cidr_ipv4, null)
  cidr_ipv6       = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", null)
}