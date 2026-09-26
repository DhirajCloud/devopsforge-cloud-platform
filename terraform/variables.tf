variable "aws_region" {
  description = "AWS region for DevOpsForge infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for AWS resource naming"
  type        = string
  default     = "devopsforge"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
