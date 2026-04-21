terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket = "c3ops-terraform-state1"
    key    = "app-infra/prod/terraform.tfstate"
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