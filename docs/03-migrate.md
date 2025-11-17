# Phase 3: Migrate Workspace from HCP Terraform to Terraform Enterprise

Guide for migrating your workspace with imported resources from HCP Terraform to on-premises Terraform Enterprise using TFM.

---

## Quick Actions

- [ ] Install TFM CLI tool
- [ ] Configure TFM credentials (~/.tfm.hcl)
- [ ] Create destination workspace in TFE
- [ ] Configure VCS OAuth token mapping
- [ ] Run migration with TFM
- [ ] Verify workspace and state in TFE
- [ ] Test workspace operations in TFE

---

## Latest Updates

- 2025-11-16: Initial migration documentation created for TFM workflow

---

## Overview

**What this phase does**:
- Migrates workspace from HCP Terraform to Terraform Enterprise
- Preserves imported state from Search & Import
- Maintains VCS connection
- Transfers variables and workspace settings

**Why it matters**:
- Enables on-premises Terraform governance
- Maintains air-gapped infrastructure control
- Completes the TFC-to-TFE migration journey

**Tool**: [TFM](https://github.com/hashicorp-services/tfm) - HashiCorp Services migration tool

---

## Prerequisites

### Completed Previous Phases
- ✅ Phase 1: Resources discovered via Search & Import
- ✅ Phase 2: Resources imported into HCP Terraform workspace
- ✅ Workspace contains valid state with imported resources

### Required Access
- **HCP Terraform**: Personal or Team token with workspace admin permissions
- **Terraform Enterprise**: Personal or Team token with workspace admin permissions
- Both tokens need permissions to:
  - Create/manage workspaces
  - Read/write state
  - Configure VCS

### Environment Requirements
- Go 1.19+ (to install TFM)
- Network access to both HCP Terraform and TFE
- VCS OAuth token configured in destination TFE instance

---

## Step 1: Install TFM

### Option A: Install via Go

```bash
go install github.com/hashicorp-services/tfm@latest

# Verify installation
tfm version
```

### Option B: Download Binary

```bash
# Download from GitHub releases
# https://github.com/hashicorp-services/tfm/releases

# Make executable
chmod +x tfm
sudo mv tfm /usr/local/bin/
```

---

## Step 2: Configure TFM Credentials

Create `~/.tfm.hcl` with your source and destination credentials:

```hcl
# ~/.tfm.hcl

# Source: HCP Terraform
source_hostname = "app.terraform.io"
source_organization = "YOURORG"
source_token = "YOUR_HCP_TERRAFORM_TOKEN"

# Destination: Terraform Enterprise
destination_hostname = "tfe.example.com"
destination_organization = "YOURORG-tfe"
destination_token = "YOUR_TFE_TOKEN"

# VCS OAuth Token Mapping (HCP TFC → TFE)
# Get these from your VCS settings in each platform
vcs_map = {
  "ot-VB3SjKNb7nPQGvcV" = "ot-NEW_TFE_OAUTH_TOKEN_ID"
}
```

**Getting OAuth Token IDs**:
1. **HCP Terraform**: Settings → Version Control → OAuth Token ID
2. **TFE**: Admin → VCS Providers → OAuth Token ID

**Alternative: Environment Variables**

```bash
export SRC_TFE_HOSTNAME="app.terraform.io"
export SRC_TFE_ORG="YOURORG"
export SRC_TFE_TOKEN="your-hcp-token"

export DST_TFC_HOSTNAME="tfe.example.com"
export DST_TFC_ORG="YOURORG-tfe"
export DST_TFC_TOKEN="your-tfe-token"
```

---

## Step 3: Prepare Destination TFE

### Create Target Organization (if needed)

```bash
# Via TFE UI or API
# Ensure organization exists: YOURORG-tfe
```

### Configure VCS Connection in TFE

1. Navigate to TFE Admin Settings
2. Add VCS Provider (GitHub, GitLab, etc.)
3. Complete OAuth flow
4. Note the OAuth Token ID for vcs_map

---

## Step 4: Run Migration

### Single Workspace Migration

```bash
# Migrate the resource-discovery workspace
tfm copy workspace \
  --source-name resource-discovery \
  --destination-name resource-discovery \
  --config ~/.tfm.hcl

# Or with command-line flags (no config file needed)
tfm copy workspace \
  --source-hostname app.terraform.io \
  --source-org YOURORG \
  --source-token "$HCP_TOKEN" \
  --source-name resource-discovery \
  --destination-hostname tfe.example.com \
  --destination-org YOURORG-tfe \
  --destination-token "$TFE_TOKEN" \
  --destination-name resource-discovery \
  --vcs-map "ot-VB3SjKNb7nPQGvcV=ot-NEW_TFE_OAUTH_TOKEN_ID"
```

### What TFM Migrates

✅ **Copied**:
- Workspace settings (Terraform version, execution mode, etc.)
- Current state file
- Environment variables
- Terraform variables
- VCS connection (via OAuth mapping)
- SSH keys (via ssh-map if configured)
- Agent pools (via agents-map if configured)

❌ **Not Copied**:
- Run history
- State versions history (only latest state)
- Notifications
- Team permissions (must be reconfigured in TFE)

### Review Migration Plan

TFM will show you what it plans to do and ask for confirmation:

```
Planning to migrate workspace:
  Source: YOURORG/resource-discovery (app.terraform.io)
  Destination: YOURORG-tfe/resource-discovery (tfe.example.com)

  Settings:
    - Terraform Version: 1.14.0-rc2
    - Execution Mode: remote
    - VCS Repo: stoffee/tfc-search-2-tfe
    - Working Directory: terraform/aws-ec2/discovery/

  State:
    - Resources: 1 (aws_instance.all_0)

  Variables:
    - Environment Variables: 4
    - Terraform Variables: 0

Do you want to proceed? (yes/no):
```

Type `yes` to proceed.

---

## Step 5: Verify Migration

### Check Workspace in TFE

1. **Navigate to TFE workspace**:
   ```
   https://tfe.example.com/app/YOURORG-tfe/workspaces/resource-discovery
   ```

2. **Verify Settings**:
   - ✅ Terraform version: 1.14.0-rc2
   - ✅ Execution mode: remote
   - ✅ VCS connected: stoffee/tfc-search-2-tfe
   - ✅ Working directory: terraform/aws-ec2/discovery/

3. **Verify State**:
   - Click "States" tab
   - Should see 1 resource: `aws_instance.all_0`

4. **Verify Variables**:
   - Check environment variables (AWS credentials)
   - All variables should be migrated

### Test Workspace Operations

```bash
# Update your local backend config to point to TFE
cd terraform/aws-ec2/discovery

# Edit versions.tf or create a new cloud config
cat > tfe-backend.tf << 'EOF'
terraform {
  cloud {
    hostname = "tfe.example.com"
    organization = "YOURORG-tfe"

    workspaces {
      name = "resource-discovery"
    }
  }
}
EOF

# Login to TFE
terraform login tfe.example.com

# Initialize with new backend
terraform init

# Verify state
terraform state list
# Should show: aws_instance.all_0

# Run plan to verify everything works
terraform plan
# Should show: No changes. Your infrastructure matches the configuration.
```

---

## Step 6: Clean Up HCP Terraform (Optional)

Once verified, you can optionally delete the source workspace:

```bash
# Via HCP Terraform UI:
# Workspace Settings → Destruction and Deletion → Delete Workspace

# Or keep it as backup until fully validated
```

---

## Advanced: Batch Migration

### Migrate Multiple Workspaces

Create workspace list in `~/.tfm.hcl`:

```hcl
source_hostname = "app.terraform.io"
source_organization = "YOURORG"
source_token = "YOUR_HCP_TOKEN"

destination_hostname = "tfe.example.com"
destination_organization = "YOURORG-tfe"
destination_token = "YOUR_TFE_TOKEN"

# List of workspaces to migrate
workspaces = [
  "resource-discovery",
  "workspace-2",
  "workspace-3"
]

vcs_map = {
  "ot-OLD_ID" = "ot-NEW_ID"
}
```

Run batch migration:

```bash
tfm copy workspaces --config ~/.tfm.hcl
```

---

## Success Criteria

✅ **Migration Complete When**:
1. Workspace exists in TFE with correct settings
2. State file in TFE shows all imported resources
3. VCS connection works (pushes trigger runs)
4. Variables are present and accessible
5. `terraform plan` shows no changes
6. Team can run applies successfully

---

## Next Steps

After successful migration:
1. **Update documentation** with TFE workspace URLs
2. **Update team access** - configure RBAC in TFE
3. **Configure notifications** - Slack/email alerts
4. **Set up run triggers** if using workspace dependencies
5. **Update CI/CD pipelines** to use TFE instead of HCP Terraform

---

## Key Takeaways

- **TFM automates** HCP Terraform → TFE migration
- **VCS mapping** preserves repository connections
- **State migration** maintains imported resources
- **Workspace settings** are preserved automatically
- **Variables transfer** including sensitive values
- **Verification is critical** before decommissioning source

---

## Resources

- [TFM GitHub Repository](https://github.com/hashicorp-services/tfm)
- [TFM Documentation](https://hashicorp-services.github.io/tfm/)
- [Terraform Enterprise Documentation](https://developer.hashicorp.com/terraform/enterprise)
- [Workspace Migration Support](https://support.hashicorp.com/hc/en-us/articles/360001151948)
