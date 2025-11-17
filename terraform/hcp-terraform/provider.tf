provider "tfe" {
  # Token should be set via TFE_TOKEN environment variable
  # or through terraform.tfvars (not recommended for security)
  # token = var.tfe_token

  # Hostname defaults to app.terraform.io for HCP Terraform
  # Override if using Terraform Enterprise
  hostname = var.tfe_hostname
}
