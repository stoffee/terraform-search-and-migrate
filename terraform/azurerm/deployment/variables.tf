# ============================================
# Azure Configuration
# ============================================

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "West US 2"
}

# ============================================
# Resource Group Configuration
# ============================================

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "search-import-demo-rg"
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
