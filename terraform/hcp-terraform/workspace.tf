# ============================================
# HCP Terraform Workspace for Resource Discovery
# ============================================

resource "tfe_workspace" "discovery" {
  name         = var.workspace_name
  organization = var.tfe_organization
  description  = var.workspace_description

  # Terraform version - must be 1.14.0-beta or newer for Search & Import
  terraform_version = var.terraform_version

  # Workspace behavior
  auto_apply            = var.auto_apply
  queue_all_runs        = var.queue_all_runs
  file_triggers_enabled = var.file_triggers_enabled
  allow_destroy_plan    = var.allow_destroy_plan
  speculative_enabled   = var.speculative_enabled

  # Working directory (for VCS-driven workflows)
  working_directory = var.working_directory

  # Tags for organization
  tag_names = var.workspace_tags

  # VCS configuration (optional - for VCS-driven workflow)
  dynamic "vcs_repo" {
    for_each = var.vcs_repo_identifier != "" ? [1] : []
    content {
      identifier     = var.vcs_repo_identifier
      oauth_token_id = var.vcs_oauth_token_id
      branch         = var.vcs_branch
    }
  }
}

# ============================================
# Workspace Settings (execution mode and agent pool)
# ============================================

resource "tfe_workspace_settings" "discovery" {
  workspace_id   = tfe_workspace.discovery.id
  execution_mode = var.execution_mode
  agent_pool_id  = var.execution_mode == "agent" ? var.agent_pool_id : null
}

# ============================================
# AWS Environment Variables (if using AWS)
# ============================================

resource "tfe_variable" "aws_access_key_id" {
  count = var.aws_access_key_id != "" ? 1 : 0

  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "AWS access key ID for resource discovery"
  sensitive    = true
}

resource "tfe_variable" "aws_secret_access_key" {
  count = var.aws_secret_access_key != "" ? 1 : 0

  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "AWS secret access key for resource discovery"
  sensitive    = true
}

resource "tfe_variable" "aws_session_token" {
  count = var.aws_session_token != "" ? 1 : 0

  key          = "AWS_SESSION_TOKEN"
  value        = var.aws_session_token
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "AWS session token for temporary credentials"
  sensitive    = true
}

resource "tfe_variable" "aws_region" {
  count = var.aws_region != "" ? 1 : 0

  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_region
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "AWS region for resource discovery"
}

# ============================================
# Azure Environment Variables (if using Azure)
# ============================================

resource "tfe_variable" "azure_subscription_id" {
  count = var.azure_subscription_id != "" ? 1 : 0

  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.azure_subscription_id
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "Azure subscription ID for resource discovery"
  sensitive    = true
}

resource "tfe_variable" "azure_client_id" {
  count = var.azure_client_id != "" ? 1 : 0

  key          = "ARM_CLIENT_ID"
  value        = var.azure_client_id
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "Azure client ID for resource discovery"
  sensitive    = true
}

resource "tfe_variable" "azure_client_secret" {
  count = var.azure_client_secret != "" ? 1 : 0

  key          = "ARM_CLIENT_SECRET"
  value        = var.azure_client_secret
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "Azure client secret for resource discovery"
  sensitive    = true
}

resource "tfe_variable" "azure_tenant_id" {
  count = var.azure_tenant_id != "" ? 1 : 0

  key          = "ARM_TENANT_ID"
  value        = var.azure_tenant_id
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "Azure tenant ID for resource discovery"
  sensitive    = true
}

# ============================================
# GCP Environment Variables (if using GCP)
# ============================================

resource "tfe_variable" "gcp_project_id" {
  count = var.gcp_project_id != "" ? 1 : 0

  key          = "GOOGLE_PROJECT"
  value        = var.gcp_project_id
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "GCP project ID for resource discovery"
}

resource "tfe_variable" "gcp_credentials" {
  count = var.gcp_credentials != "" ? 1 : 0

  key          = "GOOGLE_CREDENTIALS"
  value        = var.gcp_credentials
  category     = "env"
  workspace_id = tfe_workspace.discovery.id
  description  = "GCP service account credentials for resource discovery"
  sensitive    = true
}
