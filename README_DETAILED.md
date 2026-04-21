# App Infrastructure as Code

This repository contains Terraform infrastructure code for deploying a complete application infrastructure on AWS across three environments: test, preprod, and prod.

## Project Structure

```
App-infra/
├── src/                          # Application source files
│   └── sample.html              # Sample HTML file
├── modules/                      # Terraform modules
│   ├── alb/                     # Application Load Balancer
│   ├── ec2/                     # EC2 instances
│   ├── asg/                     # Auto Scaling Groups
│   ├── s3/                      # S3 buckets
│   ├── rds/                     # RDS database instances
│   ├── security_groups/         # Security groups
│   ├── route53/                 # Route53 DNS
│   ├── launch_templates/        # EC2 launch templates
│   └── tagging/                 # Common tagging strategy
└── environments/                # Environment-specific configurations
    ├── test/                    # Test environment
    ├── preprod/                 # Pre-production environment
    └── prod/                    # Production environment
```

## Modules Overview

### ALB Module (`modules/alb/`)
- Creates Application Load Balancer
- Configures target groups
- Sets up listeners
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### EC2 Module (`modules/ec2/`)
- Launches individual EC2 instances
- Configures security groups and subnets
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### ASG Module (`modules/asg/`)
- Creates Auto Scaling Groups
- Links to launch templates
- Integrates with load balancers
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### S3 Module (`modules/s3/`)
- Creates S3 buckets
- Enables versioning
- Configures server-side encryption
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### RDS Module (`modules/rds/`)
- Provisions RDS database instances
- Supports MySQL, PostgreSQL, and other engines
- Configures security groups and subnets
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### Security Groups Module (`modules/security_groups/`)
- Creates custom security groups
- Manages ingress and egress rules
- Supports CIDR blocks and referenced security groups
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### Route53 Module (`modules/route53/`)
- Creates hosted zones
- Manages DNS records
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### Launch Templates Module (`modules/launch_templates/`)
- Creates EC2 launch templates
- Configures user data scripts
- Applies tags
- **Files**: `main.tf`, `variables.tf`, `outputs.tf`

### Tagging Module (`modules/tagging/`)
- Provides consistent tagging strategy
- Merges environment-specific and common tags
- **Files**: `main.tf`, `variables.tf`

## Environments

### Test Environment (`environments/test/`)
- Development and testing environment
- Lower resource scaling
- Used for validation before moving to preprod

### Pre-prod Environment (`environments/preprod/`)
- Pre-production environment
- Production-like configuration
- Used for staging and final testing

### Production Environment (`environments/prod/`)
- Production environment
- High availability configuration
- Enhanced monitoring and security

## Core Infrastructure Integration

Each environment references the core infrastructure created separately via `terraform_remote_state` data source. This enables:
- Separation of concerns
- Independent lifecycle management
- Cross-stack references for network and IAM resources

## Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS credentials configured
- Core infrastructure already deployed

### Deployment Steps

1. **Navigate to desired environment**:
   ```bash
   cd environments/test
   # or
   cd environments/preprod
   # or
   cd environments/prod
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review planned changes**:
   ```bash
   terraform plan
   ```

4. **Apply configuration**:
   ```bash
   terraform apply
   ```

## Variable Configuration

Each environment has its own `variables.tf` with sensible defaults:
- `aws_region`: AWS region (default: us-east-1)
- `environment`: Environment name (test, preprod, prod)
- `common_tags`: Tags applied to all resources

Override defaults with `.tfvars` files:
```bash
terraform apply -var-file="test.tfvars"
```

## Outputs

Each environment provides outputs including:
- Environment name
- AWS region
- Resource identifiers (ALB DNS, RDS endpoint, etc.)
- Security group IDs
- S3 bucket names

## Tagging Strategy

All resources are automatically tagged with:
- **Environment**: test, preprod, or prod
- **ManagedBy**: Terraform
- **Custom tags**: Defined in common_tags variable

## Example Module Usage

### Creating Resources in an Environment

```hcl
module "security_group_app" {
  source = "../../modules/security_groups"
  
  name        = "${var.environment}-app-sg"
  description = "Security group for app servers"
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
    all_traffic = {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  
  tags = merge(local.environment_tags, {
    Name = "${var.environment}-app-sg"
  })
}
```

## Best Practices

1. **Always review plan before apply**
2. **Use terraform.tfstate remote backend in production**
3. **Maintain separate state files per environment**
4. **Use -var-file for sensitive variables**
5. **Apply consistent naming conventions**
6. **Document resource purposes in comments**
7. **Test changes in test environment first**

## Troubleshooting

### State File Issues
- Ensure core infrastructure state file path is correct
- Verify terraform.tfstate file exists in Core-infra directory

### Remote State References
- Update paths in `data.terraform_remote_state.core` if directory structure changes
- Use `terraform refresh` if outputs become stale

### Module Dependencies
- Ensure all required variables are provided
- Check security group references and CIDR blocks
- Verify subnet IDs and availability zones

## Contributing

1. Create a feature branch
2. Make changes following Terraform best practices
3. Test in test environment
4. Submit pull request
5. Deploy to preprod for validation
6. Deploy to prod after approval

## License

[Add your license information here]

## Support

For issues or questions, contact the DevOps team.
