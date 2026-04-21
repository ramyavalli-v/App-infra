resource "aws_autoscaling_group" "this" {
  name                 = var.name
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnets

  target_group_arns = var.target_group_arns

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}