# Phase 1: Resource Discovery with HCP Terraform Search

Step-by-step guide for discovering unmanaged infrastructure using HCP Terraform's Search & Import feature.

---

## Quick Actions

- [ ] Deploy EC2 instance infrastructure
- [ ] Create HCP Terraform workspace
- [ ] Add AWS credentials to workspace
- [ ] Run Search & Import query
- [ ] Review discovered resources
- [ ] Proceed to [Phase 2: Import](02-import.md)

---

## Overview

**What this phase does**:
- Deploys a simple EC2 instance to AWS
- Creates an HCP Terraform workspace connected to VCS
- Discovers the unmanaged EC2 instance using Search & Import
- Prepares for importing the resource into Terraform state

---

## Prerequisites

### Required Access
- AWS account with permissions to create EC2 instances
- HCP Terraform account (app.terraform.io)
- GitHub account with this repository forked/cloned

### Required Versions
- Terraform 1.14.0-rc2 or newer (for Search & Import feature)

---

## Step 1: Deploy EC2 Instance

Navigate to the deployment directory and deploy the infrastructure:

```bash
cd terraform/aws-ec2/deployment

# Initialize Terraform
terraform init

# Review what will be created (1 EC2 instance)
terraform plan

# Deploy the EC2 instance
terraform apply
```

**What gets created**:
- 1 EC2 instance (t3.micro) named `search-import-demo-ec2`

**Save the outputs** - you'll need the instance ID later:
```bash
terraform output instance_id
# Output: i-032e6857cb3047b31
```

---

## Step 2: Create HCP Terraform Workspace

Navigate to the workspace creation directory:

```bash
cd ../../hcp-terraform

# Copy the example file and edit with your settings
cp terraform.tfvars.example terraform.tfvars
```

**Edit `terraform.tfvars`** with your settings:

```hcl
# Organization name
tfe_organization = "your-org-name"

# Workspace name
workspace_name = "resource-discovery"

# Terraform version
terraform_version = "1.14.0-rc2"

# VCS connection
vcs_repo_identifier = "your-github-username/tfc-search-2-tfe"
vcs_oauth_token_id  = "ot-YOUR_OAUTH_TOKEN_ID"  # Get from HCP Terraform VCS settings
vcs_branch          = "main"
working_directory   = "terraform/aws-ec2/discovery/"
```

**Create the workspace**:

```bash
# Initialize
terraform init

# Review workspace configuration
terraform plan

# Create the workspace in HCP Terraform
terraform apply
```

---

## Step 3: Add AWS Credentials to Workspace

Add your AWS credentials as **environment variables** in the HCP Terraform workspace:

**Via HCP Terraform UI**:
1. Go to: `https://app.terraform.io/app/YOUR_ORG/workspaces/resource-discovery`
2. Click **Variables**
3. Add these **Environment Variables** (mark as sensitive):
   - `AWS_ACCESS_KEY_ID` = your access key
   - `AWS_SECRET_ACCESS_KEY` = your secret key
   - `AWS_SESSION_TOKEN` = your session token (if using temporary creds)
   - `AWS_DEFAULT_REGION` = `us-west-2`

---

## Step 4: Configure Discovery Query

The discovery query is already configured in:
**File**: `terraform/aws-ec2/discovery/discovery.tfquery.hcl`

```hcl
# Discovery configuration for HCP Terraform Search & Import
# For demo purposes, we only discover the EC2 instance we deployed

list "aws_instance" "all" {
  provider = aws
}
```

This tells HCP Terraform to search for all EC2 instances in your AWS account.

**No changes needed** - this file is already committed to the repository.

---

## Step 5: Run Search & Import

### Trigger Initial Run

Commit and push to trigger the workspace (or manually queue a run):

```bash
cd ../aws-ec2/discovery

# Ensure discovery.tfquery.hcl is committed
git add discovery.tfquery.hcl
git commit -m "Add discovery query"
git push origin main
```

### Access Search & Import UI

1. Go to your workspace:
   ```
   https://app.terraform.io/app/YOUR_ORG/workspaces/resource-discovery
   ```

2. Click **Search & Import** tab in the left sidebar

3. Click **"New Query"** button

4. HCP Terraform will:
   - Read `discovery.tfquery.hcl` from your repository
   - Query AWS for EC2 instances
   - Display results

---

## Step 6: Review Discovered Resources

You should see your EC2 instance in the search results:

**Expected Results**:
- **Resource**: `search-import-demo-ec2`
- **Type**: `aws_instance`
- **Status**: **Unmanaged** (not in any Terraform state)
- **Instance ID**: `i-032e6857cb3047b31` (your instance ID)

**Resource Status Meanings**:
- **Unmanaged** = Not managed by any workspace (ready to import!)
- **Managed** = Already managed by this or another workspace
- **Unknown** = Cannot determine management status

---

## Next Steps

Once you see your EC2 instance as "Unmanaged":

✅ **Phase 1 Complete!**

Proceed to [Phase 2: Import Resources](02-import.md) to:
1. Generate import configuration
2. Clean up generated config
3. Import the EC2 instance into Terraform state

---

## Directory Structure

```
terraform/aws-ec2/
├── deployment/           # ← Step 1: Deploy EC2 instance
│   ├── main.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
└── discovery/           # ← Step 4-6: Discovery configuration
    ├── discovery.tfquery.hcl  # Search query
    ├── provider.tf            # AWS provider
    └── versions.tf            # Terraform & backend config

terraform/hcp-terraform/  # ← Step 2: Create workspace
├── workspace.tf
├── terraform.tfvars
└── ...
```

---

## Beta Limitations

**Only 3 AWS resource types supported**:
- ✅ `aws_instance` (EC2)
- ✅ `aws_iam_role`
- ✅ `aws_cloudwatch_log_group`

**Not supported**:
- ❌ `aws_vpc`
- ❌ `aws_subnet`
- ❌ Most other AWS resources

This is a beta feature - more resource types will be added in future releases.

---

## Key Takeaways

- **Simple deployment** - Just one EC2 instance for demo
- **VCS-driven workflow** - All configuration in Git
- **Search & Import UI** - Server-side resource discovery
- **`.tfquery.hcl` files** - Define what to search for
- **Unmanaged resources** - Ready for import into Terraform

---

## Resources

- [HCP Terraform Search & Import Docs](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [Terraform 1.14 Release Notes](https://github.com/hashicorp/terraform/releases/tag/v1.14.0-rc2)
- [AWS Provider - Supported List Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
