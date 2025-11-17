# EC2 Discovery Configuration

This directory contains the Search & Import configuration to discover our simple EC2 instance.

## Quick Start

**Prerequisites**:
1. EC2 instance deployed (from `../deployment/`)
2. HCP Terraform workspace `resource-discovery` exists
3. Workspace connected to this repo with working directory: `terraform/aws-ec2/discovery`
4. AWS credentials set as workspace environment variables

## What to Expect

**Will be discovered** (beta supported):
- ✅ EC2 instance: `search-import-demo-ec2`
- ✅ Any IAM roles in your account
- ✅ Any CloudWatch log groups

## Steps

### 1. Verify Prerequisites

Make sure workspace has AWS credentials:
- Go to: https://app.terraform.io/app/hc-stoffee/workspaces/resource-discovery/variables
- Set environment variables:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN` (if using temporary creds)
  - `AWS_DEFAULT_REGION` = `us-west-2`

### 2. Run Query in HCP Terraform UI

1. Go to workspace: https://app.terraform.io/app/hc-stoffee/workspaces/resource-discovery
2. Click **Search & Import** tab
3. Click **New Query**
4. HCP Terraform will:
   - Read `discovery.tfquery.hcl` from VCS
   - Execute queries against AWS
   - Show discovered resources

### 3. Expected Results

You should see:
- **1 EC2 instance** (search-import-demo-ec2) marked as "Unmanaged"
- **Multiple IAM roles** (depending on your account)
- **Multiple CloudWatch log groups** (depending on your account)

### 4. Generate Import Configuration

1. Select the EC2 instance (check the box)
2. Click **"Generate configuration"**
3. Copy the generated code
4. Save to `generated.tf` in this directory

### 5. Clean Up Generated Configuration

**Important**: HCP Terraform Search & Import reads the actual AWS state and generates config with all attributes. However, some attribute combinations conflict in Terraform HCL syntax. This is a known limitation of the beta.

For EC2 instances with `primary_network_interface` blocks, you'll need to remove these conflicting top-level attributes:

```hcl
# Remove these lines (all conflict with primary_network_interface):
  associate_public_ip_address          = true
  ipv6_address_count                   = 0      # ← Also conflicts with ipv6_addresses
  ipv6_addresses                       = []     # ← Also conflicts with ipv6_address_count
  private_ip                           = "172.31.34.248"
  secondary_private_ips                = []
  security_groups                      = ["default"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0ba277bc8a6298857"
  vpc_security_group_ids               = ["sg-0d9d0295acacc5e6a"]
```

**Why?** Network configuration is defined in the `primary_network_interface` block, so these top-level attributes create conflicts.

### 6. Commit and Import

5. Commit cleaned `generated.tf` and push
6. VCS-driven run will import the resources

## Beta Limitations

**Only 3 AWS resource types supported**:
- ✅ aws_instance
- ✅ aws_iam_role
- ✅ aws_cloudwatch_log_group

**Not supported**:
- ❌ aws_vpc
- ❌ aws_subnet
- ❌ aws_security_group
- ❌ And most other AWS resources

## Current Files

- `discovery.tfquery.hcl` - Query configuration with list blocks
- `provider.tf` - AWS provider configuration
- `versions.tf` - Terraform and HCP Terraform backend config
- `README.md` - This file

**After generating imports**:
- `generated-imports.tf` - Import blocks + resource configurations
