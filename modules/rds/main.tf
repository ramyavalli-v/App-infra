
resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.identifier}-db-subnet-group"
    }
  )
}


resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.db_name
  username = var.username
  password = var.password

  vpc_security_group_ids = var.security_groups

  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}
