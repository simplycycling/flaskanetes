terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "flaskanetes-terraform-state-syd"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "flaskanetes"
      Terraform   = "true"
    }
  }
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "flaskanetes"
  tags = {
    Environment = "dev"
  }
}

module "iam" {
  source = "../../modules/iam"

  project     = var.project
  environment = var.environment
  github_org  = "simplycycling"  
  github_repo = "flaskanetes"
  tags = {
    Environment = "dev"
  }
}

# Output the repository URL for use in GitHub Actions
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

# Output the IAM role ARN for use in GitHub Actions
output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = module.iam.github_actions_role_arn
} 