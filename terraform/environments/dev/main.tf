terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "flaskanetes-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"

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

# Output the repository URL for use in GitHub Actions
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
} 