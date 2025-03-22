resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_acm_certificate.this.domain_validation_options : record.resource_record_name]
}

output "certificate_arn" {
  description = "ARN of the issued certificate"
  value       = aws_acm_certificate.this.arn
} 