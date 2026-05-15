# Phase 1 (Azure): Resource Discovery with HCP Terraform Search

Step-by-step guide for discovering unmanaged Azure infrastructure using HCP Terraform's Search & Import feature.

---

## Quick Actions

- [ ] Deploy Azure Resource Group + Public IP
- [ ] Create HCP Terraform workspace for Azure
- [ ] Add Azure credentials to workspace
- [ ] Run Search & Import query
- [ ] Review discovered resources
- [ ] Proceed to import

---

## Overview

**What this phase does**:
- Deploys a Resource Group and Public IP to Azure
- Creates an HCP Terraform workspace for Azure discovery
- Discovers the unmanaged resources using Search & Import
- Prepares for importing resources into Terraform state

---

## Prerequisites

### Required Access
- Azure subscription with Contributor or Owner role
- HCP Terraform account (app.terraform.io)
- Service principal OR Azure CLI access

### Required Versions
- Terraform 1.14.0 or newer (for Search & Import feature)
- AzureRM Provider 4.58.0 or later

---

## Step 1: Deploy Azure Resources

Navigate to the deployment directory and deploy:

```bash
cd terraform/azurerm/deployment

# Copy the example vars file and edit
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Deploy: 1 Resource Group + 1 Public IP
terraform apply
```

**What gets created**:
- 1 Azure Resource Group named `search-import-demo-rg`
- 1 Standard Public IP named `search-import-demo-rg-pip`

**Save the outputs** — you'll need the resource group name later:
```bash
terraform output resource_group_name
# Output: search-import-demo-rg
```

---

## Step 2: Create HCP Terraform Workspace

```bash
cd ../../hcp-terraform

cp terraform.tfvars.example terraform.tfvars
```

**Edit `terraform.tfvars`** with your settings:

```hcl
tfe_organization = "your-org-name"
workspace_name   = "azure-resource-discovery"
terraform_version = "1.14.0"

# VCS connection (optional - for VCS-driven workflow)
vcs_repo_identifier = "your-github-username/terraform-search-and-migrate"
vcs_oauth_token_id  = "ot-YOUR_OAUTH_TOKEN_ID"
vcs_branch          = "main"
working_directory   = "terraform/azurerm/discovery/"
```

**Create the workspace**:

```bash
terraform init
terraform plan
terraform apply
```

---

## Step 3: Add Azure Credentials to Workspace

Add credentials as **environment variables** in the HCP Terraform workspace:

**Via HCP Terraform UI**:
1. Go to: `https://app.terraform.io/app/YOUR_ORG/workspaces/azure-resource-discovery`
2. Click **Variables**
3. Add these **Environment Variables** (mark as sensitive):

| Variable | Value |
|----------|-------|
| `ARM_SUBSCRIPTION_ID` | Your Azure subscription ID |
| `ARM_TENANT_ID` | Your Azure AD tenant ID |
| `ARM_CLIENT_ID` | Service principal client ID |
| `ARM_CLIENT_SECRET` | Service principal client secret |

**Create a service principal** (if you don't have one):
```bash
az login
az ad sp create-for-rbac --name "hcp-terraform-discovery" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

---

## Step 4: Configure Discovery Query

The discovery query is already configured in:
**File**: `terraform/azurerm/discovery/discovery.tfquery.hcl`

Key entries:
```hcl
# Discover all Resource Groups
list "azurerm_resource_group" "all" {
  provider = azurerm
}

# Discover all Public IPs
list "azurerm_public_ip" "all" {
  provider = azurerm
}
```

**No changes needed** — this file is already committed.

---

## Step 5: Run Search & Import

### Trigger Initial Run

```bash
cd terraform/azurerm/discovery

# Ensure discovery.tfquery.hcl is committed
git add discovery.tfquery.hcl
git commit -m "Add Azure discovery query"
git push origin main
```

### Access Search & Import UI

1. Go to your workspace:
   ```
   https://app.terraform.io/app/YOUR_ORG/workspaces/azure-resource-discovery
   ```

2. Click **Search & Import** in the left sidebar

3. Click **New Query**

4. HCP Terraform will:
   - Read `discovery.tfquery.hcl` from your repository
   - Query Azure for resources across all supported types
   - Display results with management status

---

## Step 6: Review Discovered Resources

You should see your deployed resources:

**Expected Results**:
- `search-import-demo-rg` — Resource Group — **Unmanaged**
- `search-import-demo-rg-pip` — Public IP — **Unmanaged**

**Resource Status Meanings**:
- **Unmanaged** = Not managed by any workspace (ready to import!)
- **Managed** = Already managed by this or another workspace
- **Unknown** = Cannot determine management status

---

## Directory Structure

```
terraform/azurerm/
├── deployment/           # Step 1: Deploy Azure resources
│   ├── main.tf           # Resource Group + Public IP
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
│
└── discovery/            # Steps 4-6: Discovery configuration
    ├── discovery.tfquery.hcl  # Search query (28 resource types)
    ├── provider.tf
    ├── versions.tf
    └── README.md

terraform/hcp-terraform/  # Step 2: Create workspace
├── workspace.tf          # Already supports Azure credentials
├── variables.tf
└── ...
```

---

## Supported Azure Resources (as of AzureRM 4.64+)

28 confirmed resource types including:

| Category | Resources |
|----------|-----------|
| Management | Resource Groups |
| Networking | App Gateways, Firewalls, Public IPs, Private Endpoints, NAT Gateways, WAF Policies |
| Database | Azure SQL, MySQL Flexible Server, Elastic Pools |
| Cache | Redis Cache |
| Storage | Customer-Managed Keys |
| Compute | App Service Plans |
| AI | Cognitive Services |

Support is growing — check the [AzureRM CHANGELOG](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG.md) for new additions.

---

## Resources

- [HCP Terraform Search & Import Docs](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [AzureRM CHANGELOG](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG.md)
