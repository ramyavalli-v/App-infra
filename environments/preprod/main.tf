terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket = "c3ops-terraform-state1"
    key    = "app-infra/preprod/terraform.tfstate"
    region = "ap-south-1"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.environment_tags
  }
}

module "tagging" {
  source = "../../modules/tagging"
  
  environment  = var.environment
  common_tags  = var.common_tags
}

locals {
  environment_tags = module.tagging.tags
}

# Reference to core infra
data "terraform_remote_state" "core" {
  backend = "s3"
  
  config = {
    bucket = "c3ops-terraform-state1"
    key    = "core-infra/ap-south-1/terraform.tfstate"
    region = "ap-south-1"
  }
}

# ALB Configuration
module "alb" {
  source = "../../modules/alb"
  
  name               = "${var.environment}-app-alb"
  internal           = false
  security_groups    = [module.alb_sg.security_group_id]
  subnets            = data.terraform_remote_state.core.outputs.public_subnet_ids
  
  enable_deletion_protection = false
  
  target_group_name     = "${var.environment}-app-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id               = data.terraform_remote_state.core.outputs.vpc_id
  
  listener_port     = 80
  listener_protocol = "HTTP"
  
  tags = local.environment_tags
}

# Launch Template for ASG
module "launch_template" {
  source = "../../modules/launch_templates"
  
  name_prefix   = "${var.environment}-app-lt"
  ami           = "ami-05d2d839d4f73aafb"  # Replace with actual AMI ID
  instance_type = var.instance_type
  key_name      = "aws-keypair"  # Replace with actual key pair name
  
  security_groups = [module.app_sg.security_group_id]
  user_data       = base64encode("#!/bin/bash\necho 'Hello from ${var.environment}' > /var/www/html/index.html")
  
  tags = local.environment_tags
}

# ASG Configuration
module "asg" {
  source = "../../modules/asg"
  
  name                 = "${var.environment}-app-asg"
  launch_template_id   = module.launch_template.launch_template_id
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  subnets             = data.terraform_remote_state.core.outputs.private_app_subnet_ids
  target_group_arns   = [module.alb.target_group_arn]
  
  tags = local.environment_tags
}

# RDS Configuration
module "rds" {
  source = "../../modules/rds"
  
  identifier     = "${var.environment}-app-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t4g.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = "appdb"
  username = "admin"
  password = "RdsPassw0rd_123!"  # Use variable or secret manager
  
  db_subnet_ids       = data.terraform_remote_state.core.outputs.private_db_subnet_ids
   security_groups = [
    module.rds_sg.security_group_id
  ]
  
  skip_final_snapshot = true
  
  tags = local.environment_tags
}

# Security Groups
module "alb_sg" {
  source = "../../modules/security_groups"
  
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id
  
  ingress_rules = {
    http = {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    https = {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  egress_rules = {
    all = {
      description = "Allow all outbound"
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  tags = local.environment_tags
}

module "app_sg" {
  source = "../../modules/security_groups"
  
  name        = "${var.environment}-app-sg"
  description = "Security group for app instances"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id
  
  ingress_rules = {
    http = {
      description     = "Allow HTTP from ALB"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      referenced_sg_id = module.alb_sg.security_group_id
    }
    ssh = {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_ipv4   = "10.0.0.0/8"  # Replace with your IP range
    }
    
    https = {
      description = "HTTPS from internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
  }

  }
  
  egress_rules = {
    all = {
      description = "Allow all outbound"
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  tags = local.environment_tags
}

module "rds_sg" {
  source = "../../modules/security_groups"
  
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id
  
  ingress_rules = {
    mysql = {
      description     = "Allow MySQL from app instances"
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      referenced_security_group_id = module.app_sg.security_group_id
    }
  }
  
  egress_rules = {
    all = {
      description = "Allow all outbound"
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  tags = local.environment_tags
}