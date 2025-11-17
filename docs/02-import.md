# Phase 2: Import Resources into Terraform State

Step-by-step guide for importing discovered resources using HCP Terraform's generated configuration.

---

## Quick Actions

- [ ] Select unmanaged resources in Search & Import UI
- [ ] Generate import configuration
- [ ] Save generated config to repository
- [ ] Clean up conflicting attributes
- [ ] Commit and push to trigger import
- [ ] Verify resources in state
- [ ] Proceed to [Phase 3: Migrate](03-migrate.md)

---

## Overview

**What this phase does**:
- Generates Terraform configuration from discovered resources
- Cleans up beta limitations (conflicting attributes)
- Imports EC2 instance into Terraform state
- Verifies successful import

**Prerequisites**:
- ✅ Phase 1 complete (EC2 instance discovered as "Unmanaged")

---

## Step 1: Generate Import Configuration

From the Search & Import UI in your workspace:

1. **Select the EC2 instance**:
   - Check the box next to `search-import-demo-ec2`
   - Status should show **Unmanaged**

2. **Click "Generate configuration"** button

3. **Copy the generated code**:
   - HCP Terraform generates both `import` block AND `resource` block
   - Code appears in a text box in the UI
   - Copy ALL the generated code

**Example of what you'll see**:
```hcl
import {
  to       = aws_instance.all_0
  provider = aws
  identity = {
    account_id = "560827651034"
    id         = "i-032e6857cb3047b31"
    region     = "us-west-2"
  }
}

resource "aws_instance" "all_0" {
  provider                             = aws
  ami                                  = "ami-0717ec3ae24d01c4d"
  associate_public_ip_address          = true
  # ... many more attributes ...
}
```

---

## Step 2: Save Generated Configuration

Navigate to the discovery directory and create the generated config file:

```bash
cd terraform/aws-ec2/discovery

# Create generated.tf and paste the copied code
# Use your preferred editor (vi, nano, code, etc.)
vi generated.tf
```

**Paste the entire generated code** from the UI into this file.

---

## Step 3: Clean Up Conflicting Attributes

**Important**: HCP Terraform Search & Import reads the actual AWS state and generates config with all attributes. However, some attribute combinations conflict in Terraform HCL syntax. This is a known limitation of the beta.

### Remove Conflicting Attributes

For EC2 instances with `primary_network_interface` blocks, **remove these top-level attributes**:

```bash
# Edit generated.tf and remove these lines:
vi generated.tf
```

**Delete these specific lines**:
```hcl
# Remove these (all conflict with primary_network_interface):
  associate_public_ip_address          = true
  ipv6_address_count                   = 0
  ipv6_addresses                       = []
  private_ip                           = "172.31.34.248"
  secondary_private_ips                = []
  security_groups                      = ["default"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0ba277bc8a6298857"
  vpc_security_group_ids               = ["sg-0d9d0295acacc5e6a"]
```

**Why?** When using `primary_network_interface` block, all network configuration must be defined in that block, not as top-level resource attributes.

### What to Keep

Keep all other attributes, especially:
- ✅ `import` block (entire block)
- ✅ `resource "aws_instance"` declaration
- ✅ `ami`, `instance_type`, `monitoring`, etc.
- ✅ All nested blocks (`capacity_reservation_specification`, `cpu_options`, etc.)
- ✅ `primary_network_interface` block
- ✅ `tags` and `tags_all`

---

## Step 4: Commit and Push

Once you've cleaned up the generated config:

```bash
# Add the generated config
git add generated.tf

# Commit with descriptive message
git commit -m "Add generated import configuration for EC2 instance"

# Push to trigger VCS-driven run
git push origin main
```

**What happens next**:
- VCS push triggers a run in HCP Terraform
- Terraform reads the `import` block
- Terraform imports the EC2 instance into state
- Terraform plan should show: "No changes" (if config matches reality)

---

## Step 5: Monitor the Import Run

1. Go to your workspace:
   ```
   https://app.terraform.io/app/YOUR_ORG/workspaces/resource-discovery
   ```

2. **Watch the run progress**:
   - Should show "Plan and Apply"
   - Plan phase: Imports the resource
   - Apply phase: Updates state

3. **Expected output**:
   ```
   Plan: 0 to add, 0 to change, 0 to destroy.

   aws_instance.all_0: Importing from ID "i-032e6857cb3047b31"...
   aws_instance.all_0: Import prepared!
   aws_instance.all_0: Import complete!

   Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
   ```

---

## Step 6: Verify Import Success

### Check State in UI

1. In the workspace, click **States** tab
2. Click the latest state version
3. **Verify resource exists**:
   - Should see: `aws_instance.all_0`
   - Type: `aws_instance`
   - ID: `i-032e6857cb3047b31` (your instance ID)

### Verify Locally (Optional)

If you want to verify locally:

```bash
cd terraform/aws-ec2/discovery

# Configure backend to point to HCP Terraform
# (This is already configured in versions.tf)

# Login to HCP Terraform
terraform login

# Initialize
terraform init

# List state
terraform state list
# Output: aws_instance.all_0

# Show resource details
terraform state show aws_instance.all_0
```

### Test Plan (No Changes Expected)

```bash
# Run plan to verify configuration matches reality
terraform plan

# Expected output:
# No changes. Your infrastructure matches the configuration.
```

**If you see changes**: The generated config doesn't perfectly match AWS reality. This is normal - review the differences and adjust the `generated.tf` file as needed.

---

## What You Accomplished

✅ **Generated** Terraform configuration for existing EC2 instance
✅ **Cleaned** conflicting attributes (beta limitation)
✅ **Imported** EC2 instance into Terraform state
✅ **Verified** resource is now under Terraform management

**Your EC2 instance is now managed by Terraform!**

The instance that was created outside of Terraform is now:
- In Terraform state
- Tracked by version control
- Managed through HCP Terraform workspace
- Ready to be migrated to Terraform Enterprise (Phase 3)

---

## Next Steps

✅ **Phase 2 Complete!**

Proceed to [Phase 3: Migrate to Terraform Enterprise](03-migrate.md) to:
1. Install TFM (Terraform Migration tool)
2. Configure source and destination credentials
3. Migrate workspace from HCP Terraform to TFE
4. Verify state and VCS connection in TFE

---

## Key Takeaways

- **Search & Import** generates complete configuration automatically
- **Beta limitation** requires manual cleanup of conflicting attributes
- **Import blocks** use identity-based import (not resource IDs)
- **VCS workflow** triggers automatic import on push
- **State management** happens server-side in HCP Terraform
- **Verification** ensures configuration matches reality

---

## Resources

- [HCP Terraform Search & Import Docs](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [Import Block Syntax](https://developer.hashicorp.com/terraform/language/import)
- [AWS Provider - Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Discovery README](../terraform/aws-ec2/discovery/README.md) - Complete cleanup attribute list
