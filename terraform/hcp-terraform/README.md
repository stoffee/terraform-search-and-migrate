# HCP Terraform Workspace Setup

Terraform configuration to create an HCP Terraform workspace with Search & Import functionality enabled.

---

## Quick Start Actions

- [ ] Set TFE_TOKEN environment variable
- [ ] Copy terraform.tfvars.example to terraform.tfvars
- [ ] Update terraform.tfvars with your organization and settings
- [ ] Add cloud provider credentials to terraform.tfvars
- [ ] Run terraform init
- [ ] Run terraform plan
- [ ] Run terraform apply
- [ ] Visit workspace URL from outputs
- [ ] Navigate to Search & Import page

---

## What This Does

**Creates**:
- HCP Terraform workspace configured for resource discovery
- Terraform version set to 1.14.0-rc2 or newer (required for Search & Import)
- Cloud provider credentials as workspace environment variables
- Workspace tags for organization

**Enables**:
- Search & Import functionality (beta feature)
- Resource discovery queries
- Bulk import capabilities

---

## Prerequisites

### Required

- **HCP Terraform Account**: Active account at app.terraform.io
- **HCP Terraform Token**: User or team token with workspace create permissions
- **Terraform CLI**: Version 1.5.0 or newer installed locally
- **Organization**: Existing HCP Terraform organization

### Cloud Provider Access

At least one of:
- **AWS**: Access key ID and secret access key with read permissions
- **Azure**: Service principal with subscription read access
- **GCP**: Service account with project read access

---

## Setup Instructions

### Step 1: Get HCP Terraform Token

**Via UI**:
1. Log into app.terraform.io
2. Click your profile → **User Settings**
3. Click **Tokens** → **Create an API token**
4. Copy the token (save it - you can't see it again!)

**Set as environment variable**:
```bash
export TFE_TOKEN="your-token-here"
```

**Or add to your shell profile** (~/.zshrc):
```bash
echo 'export TFE_TOKEN="your-token-here"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Configure Variables

**Copy example file**:
```bash
cp terraform.tfvars.example terraform.tfvars
```

**Edit terraform.tfvars**:
```bash
vi terraform.tfvars
```

**Minimum required configuration**:
```hcl
# Your HCP Terraform organization
tfe_organization = "your-org-name"

# Workspace settings
workspace_name    = "resource-discovery"
terraform_version = "1.14.0-rc2"

# AWS credentials (example)
aws_access_key_id     = "AKIAIOSFODNN7EXAMPLE"
aws_secret_access_key = "your-secret-key-here"
aws_region            = "us-west-2"
```

### Step 3: Initialize Terraform

```bash
terraform init
```

**Expected output**:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/tfe versions matching "~> 0.58"...
- Installing hashicorp/tfe v0.58.x...

Terraform has been successfully initialized!
```

### Step 4: Review Plan

```bash
terraform plan
```

**Check for**:
- Workspace creation
- Environment variable resources (for cloud credentials)
- Correct Terraform version setting
- Expected tags

### Step 5: Create Workspace

```bash
terraform apply
```

**Confirm**: Type `yes` when prompted

**Expected output**:
```
Apply complete! Resources: X added, 0 changed, 0 destroyed.

Outputs:

workspace_id   = "ws-xxxxxxxxxxxxx"
workspace_name = "resource-discovery"
workspace_url  = "https://app.terraform.io/app/your-org/workspaces/resource-discovery"
workspace_search_url = "https://app.terraform.io/app/your-org/workspaces/resource-discovery/search"

next_steps = <<EOT

    Workspace created successfully!

    Next steps:
    1. Visit the workspace: resource-discovery
       https://app.terraform.io/app/your-org/workspaces/resource-discovery

    2. Go to Search & Import page:
       https://app.terraform.io/app/your-org/workspaces/resource-discovery/search

    3. Add list blocks to your Terraform configuration...

EOT
```

### Step 6: Verify Workspace

**Visit workspace URL** (from outputs):
```bash
# Copy URL from terraform output
open "$(terraform output -raw workspace_url)"
```

**Check settings**:
1. Terraform version is 1.14.0-rc2 or newer
2. Execution mode is correct (remote/local/agent)
3. Environment variables are set (check Variables section)
4. Tags are applied

**Verify Search & Import page**:
1. Click **Search & Import** in left sidebar
2. Should see "Search & Import (Beta)" page
3. Ready to add list blocks for resource discovery

---

## Configuration Options

### Execution Modes

**Remote** (default):
- Terraform runs in HCP Terraform infrastructure
- Good for team collaboration
- Recommended for getting started

**Local**:
- Terraform runs on your local machine
- State stored remotely in HCP Terraform
- Good for testing

**Agent**:
- Terraform runs on your own agent infrastructure
- Required for private networks
- Needs agent_pool_id configuration

### VCS-Driven Workflow (Optional)

Connect workspace to Git repository:

```hcl
vcs_repo_identifier = "your-org/your-repo"
vcs_oauth_token_id  = "ot-xxxxxxxxxxxxx"
vcs_branch          = "main"
```

**Get OAuth token ID**:
1. HCP Terraform → Settings → Version Control
2. Add VCS provider if not already connected
3. Copy OAuth token ID from provider settings

### Agent Pool Configuration (Optional)

For agent execution mode:

```hcl
execution_mode = "agent"
agent_pool_id  = "apool-xxxxxxxxxxxxx"
```

**Enable query operation on agent**:
```bash
tfc-agent \
  -name=discovery-agent \
  -address=https://app.terraform.io \
  -token=$AGENT_TOKEN \
  -allow-query
```

**Important**: The `-allow-query` flag is required for Search & Import!

---

## File Structure

```
terraform/hcp-terraform/
├── README.md                    # This file
├── versions.tf                  # Provider version constraints
├── provider.tf                  # TFE provider configuration
├── variables.tf                 # Input variable definitions
├── workspace.tf                 # Workspace resource configuration
├── outputs.tf                   # Output values
├── terraform.tfvars.example     # Example configuration
└── terraform.tfvars             # Your configuration (gitignored)
```

---

## Security Best Practices

### Never Commit Secrets

**Ensure .gitignore includes**:
```
terraform.tfvars
*.tfvars
*.auto.tfvars
```

**Verify**:
```bash
# Check from repo root
cat ../../.gitignore | grep tfvars
```

### Use Environment Variables

**Alternative to terraform.tfvars**:
```bash
export TF_VAR_tfe_organization="your-org"
export TF_VAR_aws_access_key_id="AKIA..."
export TF_VAR_aws_secret_access_key="secret..."

terraform apply
```

---

## Next Steps

After workspace is created:

### 1. Add List Blocks for Discovery

See: [../../docs/01-search.md](../../docs/01-search.md)

**Example** - Add to your workspace configuration:
```hcl
# discovery.tf
list "aws_instance" {}
list "aws_security_group" {}
```

### 2. Run Search Queries

1. Visit Search & Import page
2. Click "New Query"
3. Select list blocks to execute
4. Review discovered resources

### 3. Generate Import Configuration

1. Select unmanaged resources
2. Click "Generate configuration"
3. Copy import and resource blocks
4. Add to your Terraform configuration

### 4. Proceed to Import Phase

See: [../../docs/02-import.md](../../docs/02-import.md)

---

## Managing the Workspace

### Update Workspace Settings

**Edit terraform.tfvars**:
```hcl
# Change execution mode
execution_mode = "local"

# Enable auto-apply (use with caution!)
auto_apply = true
```

**Apply changes**:
```bash
terraform apply
```

### Add More Cloud Credentials

**Edit terraform.tfvars**:
```hcl
# Add Azure credentials
azure_subscription_id = "..."
azure_client_id       = "..."
azure_client_secret   = "..."
azure_tenant_id       = "..."
```

**Apply changes**:
```bash
terraform apply
```

### Destroy Workspace

**When done with discovery project**:
```bash
# Warning: This deletes the workspace and all its state!
terraform destroy
```

**Safer alternative** - Lock workspace:
1. Go to workspace Settings → Destruction and Deletion
2. Enable "Prevent destroy"
3. Archive workspace when no longer needed

---

## Additional Resources

**HCP Terraform Documentation**:
- [Workspaces](https://developer.hashicorp.com/terraform/cloud-docs/workspaces)
- [Search & Import Beta](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [TFE Provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)

**Project Documentation**:
- [Main README](../../README.md)
- [Phase 1: Search](../../docs/01-search.md)
- [Phase 2: Import](../../docs/02-import.md)
- [Phase 3: Migration](../../docs/03-migrate.md)

---

## Support

**Issues with this configuration**:
- Check troubleshooting section above
- Review HCP Terraform status page
- Open issue in this repository

**HCP Terraform support**:
- [Support portal](https://support.hashicorp.com)
- [Community forum](https://discuss.hashicorp.com/c/terraform-cloud)
