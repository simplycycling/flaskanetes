variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the ECR repository"
  type        = map(string)
  default     = {}
} 