resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  force_delete = true

  tags = merge(
    {
      Name = var.repository_name
    },
    var.tags
  )
}

# Lifecycle policy to keep only the latest 5 images
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        action = {
          type = "expire"
        }
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        description = "Keep only the latest 5 images"
        rulePriority = 1
      }
    ]
  })
}

# Output the repository URL
output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.this.name
} 