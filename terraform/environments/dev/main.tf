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

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project     = "flaskanetes"
  environment = "dev"
  vpc_cidr    = "10.0.0.0/16"

  tags = {
    Environment = "dev"
    Project     = "flaskanetes"
    Terraform   = "true"
  }
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "flaskanetes"

  tags = {
    Environment = "dev"
    Project     = "flaskanetes"
    Terraform   = "true"
  }
}

# IAM Module for GitHub Actions
module "iam" {
  source = "../../modules/iam"

  project     = "flaskanetes"
  environment = "dev"
  oidc_provider_arn = module.eks.oidc_provider_arn

  tags = {
    Environment = "dev"
    Project     = "flaskanetes"
    Terraform   = "true"
  }
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  project     = "flaskanetes"
  environment = "dev"
  kubernetes_version = "1.27"

  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_security_group_id = module.vpc.eks_cluster_security_group_id

  node_group_desired_size = 2
  node_group_max_size     = 4
  node_group_min_size     = 1
  node_group_instance_types = ["t3.medium"]

  tags = {
    Environment = "dev"
    Project     = "flaskanetes"
    Terraform   = "true"
  }
}

# Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions"
  value       = module.iam.github_actions_role_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "aws_load_balancer_controller_role_arn" {
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
  value       = module.iam.aws_load_balancer_controller_role_arn
} 