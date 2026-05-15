# ============================================
# Discovery Configuration for GCP Resources
# ============================================
# Used by HCP Terraform Search & Import to discover
# unmanaged GCP resources in your project.
#
# GCP list resource support began in hashicorp/google 7.29.0 (April 2026)
# See: https://github.com/hashicorp/terraform-provider-google/blob/main/CHANGELOG.md

variable "project_id" {
  description = "GCP project ID to discover resources in"
  type        = string
}

# ============================================
# IAM & IDENTITY
# ============================================

# Service Accounts (7.29.0+) — first GCP list resource
list "google_service_account" "all" {
  provider = google
}
