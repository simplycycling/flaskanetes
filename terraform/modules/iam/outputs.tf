output "aws_load_balancer_controller_role_arn" {
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "aws_load_balancer_controller_role_name" {
  description = "Name of the IAM role for the AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.name
} 