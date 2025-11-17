# ============================================
# TFE/HCP Terraform Configuration
# ============================================

variable "tfe_hostname" {
  description = "Hostname for HCP Terraform or Terraform Enterprise"
  type        = string
  default     = "app.terraform.io"
}

variable "tfe_organization" {
  description = "HCP Terraform organization name"
  type        = string
}

# ============================================
# Workspace Configuration
# ============================================

variable "workspace_name" {
  description = "Name of the workspace to create"
  type        = string
  default     = "resource-discovery"
}

variable "workspace_description" {
  description = "Description of the workspace"
  type        = string
  default     = "Workspace for discovering and importing unmanaged cloud resources"
}

variable "terraform_version" {
  description = "Terraform version to use (must be 1.14.0-rc2 or newer for search)"
  type        = string
  default     = "1.14.0-rc2"

  validation {
    condition     = can(regex("^1\\.(1[4-9]|[2-9][0-9])\\..*", var.terraform_version))
    error_message = "Terraform version must be 1.14.0 or newer for Search & Import functionality."
  }
}

variable "execution_mode" {
  description = "Execution mode for the workspace (remote, local, or agent)"
  type        = string
  default     = "remote"

  validation {
    condition     = contains(["remote", "local", "agent"], var.execution_mode)
    error_message = "Execution mode must be one of: remote, local, agent."
  }
}

variable "auto_apply" {
  description = "Whether to automatically apply changes"
  type        = bool
  default     = false
}

variable "queue_all_runs" {
  description = "Whether to queue all runs (vs. auto-queuing only VCS-triggered runs)"
  type        = bool
  default     = true
}

variable "file_triggers_enabled" {
  description = "Whether to trigger runs based on file changes (VCS-driven workflow)"
  type        = bool
  default     = false
}

variable "allow_destroy_plan" {
  description = "Whether destroy plans can be queued"
  type        = bool
  default     = true
}

variable "speculative_enabled" {
  description = "Whether to allow speculative plans"
  type        = bool
  default     = true
}

# ============================================
# VCS Configuration (Optional)
# ============================================

variable "vcs_repo_identifier" {
  description = "VCS repository identifier (e.g., 'org/repo-name'). Leave empty for CLI-driven workflow"
  type        = string
  default     = ""
}

variable "vcs_oauth_token_id" {
  description = "OAuth token ID for VCS connection. Leave empty for CLI-driven workflow"
  type        = string
  default     = ""
}

variable "vcs_branch" {
  description = "VCS branch to use"
  type        = string
  default     = "main"
}

variable "working_directory" {
  description = "Working directory for Terraform operations in VCS"
  type        = string
  default     = ""
}

# ============================================
# Agent Pool Configuration (Optional)
# ============================================

variable "agent_pool_id" {
  description = "Agent pool ID if using agent execution mode. Required if execution_mode is 'agent'"
  type        = string
  default     = ""
}

# ============================================
# Environment Variables for Cloud Provider
# ============================================

variable "aws_access_key_id" {
  description = "AWS access key ID (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS session token for temporary credentials (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region (will be set as workspace environment variable)"
  type        = string
  default     = "us-west-2"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure client ID (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure client secret (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "gcp_project_id" {
  description = "GCP project ID (will be set as workspace environment variable)"
  type        = string
  default     = ""
}

variable "gcp_credentials" {
  description = "GCP service account credentials JSON (will be set as workspace environment variable)"
  type        = string
  default     = ""
  sensitive   = true
}

# ============================================
# Workspace Tags
# ============================================

variable "workspace_tags" {
  description = "Tags to apply to the workspace"
  type        = list(string)
  default = [
    "search",
    "import",
    "discovery"
  ]
}
