# ============================================
# Discovery Configuration for AWS Resources
# ============================================
# This file is used by HCP Terraform Search & Import
# to discover unmanaged AWS resources
#
# Supported list resource types as of AWS Provider 6.29+
# See: https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md

# ============================================
# COMPUTE
# ============================================

# EC2 Instances
list "aws_instance" "all" {
  provider = aws
}

# ============================================
# NETWORKING
# ============================================

# VPCs
list "aws_vpc" "all" {
  provider = aws
}

# Subnets
list "aws_subnet" "all" {
  provider = aws
}

# Security Groups
list "aws_security_group" "all" {
  provider = aws
}

# ============================================
# IAM
# ============================================

# IAM Roles
list "aws_iam_role" "all" {
  provider = aws
}

# IAM Policies
list "aws_iam_policy" "all" {
  provider = aws
}

# IAM Role Policy Attachments
list "aws_iam_role_policy_attachment" "all" {
  provider = aws
}

# ============================================
# STORAGE
# ============================================

# S3 Buckets
list "aws_s3_bucket" "all" {
  provider = aws
}

# ============================================
# SECURITY / KMS
# ============================================

# KMS Keys
list "aws_kms_key" "all" {
  provider = aws
}

# KMS Aliases
list "aws_kms_alias" "all" {
  provider = aws
}

# ============================================
# MESSAGING
# ============================================

# SQS Queues
list "aws_sqs_queue" "all" {
  provider = aws
}

# ============================================
# SYSTEMS MANAGER
# ============================================

# SSM Parameters
list "aws_ssm_parameter" "all" {
  provider = aws
}

# ============================================
# MONITORING
# ============================================

# CloudWatch Log Groups
list "aws_cloudwatch_log_group" "all" {
  provider = aws
}
