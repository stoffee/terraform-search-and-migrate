# ============================================
# Discovery Configuration for AWS Resources
# ============================================
# This file is used by HCP Terraform Search & Import
# to discover unmanaged AWS resources
#
# Supported list resource types as of AWS Provider 6.45+
# See: https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md

# ============================================
# COMPUTE
# ============================================

# EC2 Instances
list "aws_instance" "all" {
  provider = aws
}

# EBS Volumes (6.42.0+)
list "aws_ebs_volume" "all" {
  provider = aws
}

# Lambda Functions
list "aws_lambda_function" "all" {
  provider = aws
}

# Lambda Event Source Mappings (6.43.0+)
list "aws_lambda_event_source_mapping" "all" {
  provider = aws
}

# EKS Clusters (6.39.0+)
list "aws_eks_cluster" "all" {
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

# VPC Security Group Ingress Rules (new separate resource type, 6.32+)
list "aws_vpc_security_group_ingress_rule" "all" {
  provider = aws
}

# VPC Security Group Egress Rules (new separate resource type, 6.32+)
list "aws_vpc_security_group_egress_rule" "all" {
  provider = aws
}

# Internet Gateways (6.42.0+)
list "aws_internet_gateway" "all" {
  provider = aws
}

# NAT Gateways (6.41.0+)
list "aws_nat_gateway" "all" {
  provider = aws
}

# Elastic IPs (6.42.0+)
list "aws_eip" "all" {
  provider = aws
}

# Route Tables
list "aws_route_table" "all" {
  provider = aws
}

# VPC Endpoints (6.38.0+)
list "aws_vpc_endpoint" "all" {
  provider = aws
}

# Load Balancers (ALB/NLB)
list "aws_lb" "all" {
  provider = aws
}

# Load Balancer Target Groups
list "aws_lb_target_group" "all" {
  provider = aws
}

# Load Balancer Listeners
list "aws_lb_listener" "all" {
  provider = aws
}

# Route53 Hosted Zones (6.42.0+)
list "aws_route53_zone" "all" {
  provider = aws
}

# CloudFront Distributions (6.41.0+)
list "aws_cloudfront_distribution" "all" {
  provider = aws
}

# ============================================
# IAM
# ============================================

# IAM Roles
list "aws_iam_role" "all" {
  provider = aws
}

# IAM Users (6.33+)
list "aws_iam_user" "all" {
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

# IAM User Policy Attachments (6.42.0+)
list "aws_iam_user_policy_attachment" "all" {
  provider = aws
}

# IAM Group Policy Attachments (6.43.0+)
list "aws_iam_group_policy_attachment" "all" {
  provider = aws
}

# SSO Admin Account Assignments (6.38.0+)
list "aws_ssoadmin_account_assignment" "all" {
  provider = aws
}

# ============================================
# STORAGE
# ============================================

# S3 Buckets
list "aws_s3_bucket" "all" {
  provider = aws
}

# S3 Directory Buckets (S3 Express One Zone, 6.34+)
list "aws_s3_directory_bucket" "all" {
  provider = aws
}

# S3 Bucket Ownership Controls (6.34+)
list "aws_s3_bucket_ownership_controls" "all" {
  provider = aws
}

# S3 Bucket Versioning (6.32+)
list "aws_s3_bucket_versioning" "all" {
  provider = aws
}

# S3 Bucket Lifecycle Configuration (6.32+)
list "aws_s3_bucket_lifecycle_configuration" "all" {
  provider = aws
}

# S3 Bucket Logging (6.44.0+)
list "aws_s3_bucket_logging" "all" {
  provider = aws
}

# S3 Files - File Systems (6.40.0+, new AWS service)
list "aws_s3files_file_system" "all" {
  provider = aws
}

# S3 Files - Access Points (6.40.0+)
list "aws_s3files_access_point" "all" {
  provider = aws
}

# ============================================
# DATABASE
# ============================================

# RDS Database Instances
list "aws_db_instance" "all" {
  provider = aws
}

# DynamoDB Tables (6.44.0+)
list "aws_dynamodb_table" "all" {
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

# SQS Queue Policies (6.42.0+)
list "aws_sqs_queue_policy" "all" {
  provider = aws
}

# SNS Topics (6.32+)
list "aws_sns_topic" "all" {
  provider = aws
}

# SNS Topic Subscriptions (6.32+)
list "aws_sns_topic_subscription" "all" {
  provider = aws
}

# SNS Topic Policies (6.41.0+)
list "aws_sns_topic_policy" "all" {
  provider = aws
}

# MSK (Managed Kafka) Clusters (6.38.0+)
list "aws_msk_cluster" "all" {
  provider = aws
}

# ============================================
# SECRETS & SYSTEMS MANAGER
# ============================================

# Secrets Manager Secrets (6.32+)
list "aws_secretsmanager_secret" "all" {
  provider = aws
}

# SSM Documents (6.37+)
list "aws_ssm_document" "all" {
  provider = aws
}

# SSM Associations (6.40.0+)
list "aws_ssm_association" "all" {
  provider = aws
}

# SSM Patch Groups (6.40.0+)
list "aws_ssm_patch_group" "all" {
  provider = aws
}

# ============================================
# MONITORING
# ============================================

# CloudWatch Log Groups
list "aws_cloudwatch_log_group" "all" {
  provider = aws
}

# CloudWatch Metric Alarms
list "aws_cloudwatch_metric_alarm" "all" {
  provider = aws
}

# CloudWatch Log Metric Filters (6.42.0+)
list "aws_cloudwatch_log_metric_filter" "all" {
  provider = aws
}

# Config Config Rules (6.40.0+)
list "aws_config_config_rule" "all" {
  provider = aws
}

# API Gateway v2 APIs (6.42.0+)
list "aws_apigatewayv2_api" "all" {
  provider = aws
}
