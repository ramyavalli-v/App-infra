resource "aws_launch_template" "this" {
  name_prefix   = var.name_prefix
  image_id      = var.ami
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = var.security_groups

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}