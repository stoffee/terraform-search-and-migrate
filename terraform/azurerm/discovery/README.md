# Azure Discovery Configuration

This directory contains the HCP Terraform workspace configuration for discovering unmanaged Azure resources using Search & Import.

## What Gets Discovered

- Resource Groups
- Networking: Public IPs, Application Gateways, Firewalls, NAT Gateways, Private Endpoints
- Database: Azure SQL Servers/Databases/Elastic Pools, MySQL Flexible Server
- Cache: Redis Cache
- Compute: App Service Plans
- AI: Cognitive Services

## Files

- `discovery.tfquery.hcl` - List block definitions for Search & Import
- `provider.tf` - AzureRM provider config
- `versions.tf` - Terraform/provider version requirements + HCP Terraform backend
- `README.md` - This file

## Credentials

Set these environment variables in your HCP Terraform workspace:

| Variable | Description |
|----------|-------------|
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure AD tenant ID |
| `ARM_CLIENT_ID` | Service principal client ID |
| `ARM_CLIENT_SECRET` | Service principal client secret |

## Running Search & Import

1. Commit `discovery.tfquery.hcl` to your VCS repo
2. In HCP Terraform → workspace → **Search & Import**
3. Click **New Query** — HCP Terraform reads the list blocks and queries Azure
4. Review discovered resources (Managed / Unmanaged / Unknown)
5. Select unmanaged resources → **Generate configuration**
6. Copy the generated `import` + `resource` blocks into your config
