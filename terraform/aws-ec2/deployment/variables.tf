# ============================================
# AWS Configuration
# ============================================

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

# ============================================
# EC2 Configuration
# ============================================

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "search-import-demo-ec2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# ============================================
# General Configuration
# ============================================

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "tfc-search-import-demo"
}
