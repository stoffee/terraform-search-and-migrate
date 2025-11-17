# ============================================
# Workspace Outputs
# ============================================

output "workspace_id" {
  description = "The ID of the created workspace"
  value       = tfe_workspace.discovery.id
}

output "workspace_name" {
  description = "The name of the created workspace"
  value       = tfe_workspace.discovery.name
}

output "workspace_url" {
  description = "Direct URL to the workspace in HCP Terraform UI"
  value       = "https://${var.tfe_hostname}/app/${var.tfe_organization}/workspaces/${tfe_workspace.discovery.name}"
}

output "workspace_search_url" {
  description = "Direct URL to the Search & Import page for this workspace"
  value       = "https://${var.tfe_hostname}/app/${var.tfe_organization}/workspaces/${tfe_workspace.discovery.name}/search"
}

output "terraform_version" {
  description = "Terraform version configured for the workspace"
  value       = tfe_workspace.discovery.terraform_version
}

output "execution_mode" {
  description = "Execution mode of the workspace"
  value       = tfe_workspace_settings.discovery.execution_mode
}

output "workspace_tags" {
  description = "Tags applied to the workspace"
  value       = tfe_workspace.discovery.tag_names
}

# ============================================
# Next Steps
# ============================================

output "next_steps" {
  description = "Instructions for next steps"
  value       = <<-EOT

    Workspace created successfully!

    Next steps:
    1. Visit the workspace: ${tfe_workspace.discovery.name}
       ${tfe_workspace.discovery.html_url}

    2. Go to Search & Import page:
       https://${var.tfe_hostname}/app/${var.tfe_organization}/workspaces/${tfe_workspace.discovery.name}/search

    3. Add list blocks to your Terraform configuration to define search queries
       Example: examples/search/discovery.tf

    4. Run queries to discover unmanaged resources

    5. Generate import configuration from search results

    6. Proceed to Phase 2: Import (docs/02-import.md)

  EOT
}
