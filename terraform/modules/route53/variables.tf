variable "zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the record"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
} 