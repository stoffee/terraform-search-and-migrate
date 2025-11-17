# HCP Terraform Search & Import to Terraform Enterprise Migration

Complete workflow for discovering cloud resources, importing to Terraform state, and migrating to Terraform Enterprise.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Phase 1: Resource Discovery](#phase-1-resource-discovery)
- [Phase 2: Import Resources](#phase-2-import-resources)
- [Phase 3: Migrate to TFE](#phase-3-migrate-to-tfe)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

**Required Access**:
- AWS account (EC2 permissions)
- HCP Terraform account (app.terraform.io)
- Terraform Enterprise instance
- GitHub account

**Required Tools**:
- Git
- Go 1.19+ (for Phase 3)

**AWS Beta Limitation**:
- Only supports: `aws_instance`, `aws_iam_role`, `aws_cloudwatch_log_group`

---

## Phase 1: Resource Discovery

### Step 1: Deploy EC2 Instance

```bash
cd terraform/aws-ec2/deployment
terraform init
terraform plan
terraform apply

# Save instance ID
terraform output instance_id
```

### Step 2: Create HCP Terraform Workspace

```bash
cd ../../hcp-terraform
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values:
# - tfe_organization
# - workspace_name
# - vcs_repo_identifier
# - vcs_oauth_token_id

terraform init
terraform plan
terraform apply
```

### Step 3: Add AWS Credentials

Go to workspace → Variables → Add environment variables:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (if needed)
- `AWS_DEFAULT_REGION` = `us-west-2`

### Step 4: Run Search & Import

```bash
cd ../aws-ec2/discovery
git push origin main  # Triggers workspace run
```

Go to workspace → Search & Import → New Query

You should see EC2 instance as **Unmanaged**.

---

## Phase 2: Import Resources

### Step 1: Generate Configuration

In Search & Import UI:
1. Select EC2 instance
2. Click "Generate configuration"
3. Copy ALL generated code

### Step 2: Save Generated Config

```bash
cd terraform/aws-ec2/discovery
vi generated.tf
# Paste copied code
```

### Step 3: Clean Up Conflicts

Remove these lines from `generated.tf`:

```hcl
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

**Why**: These conflict with `primary_network_interface` block.

### Step 4: Import

```bash
git add generated.tf
git commit -m "Add import configuration"
git push origin main
```

Watch run in HCP Terraform. Should see:
```
aws_instance.all_0: Import complete!
```

### Step 5: Verify

Go to workspace → States → Verify `aws_instance.all_0` exists.

---

## Phase 3: Migrate to TFE

### Step 1: Install TFM

```bash
go install github.com/hashicorp-services/tfm@latest
tfm version
```

### Step 2: Configure TFM

Create `~/.tfm.hcl`:

```hcl
source_hostname = "app.terraform.io"
source_organization = "your-org-name"
source_token = "YOUR_HCP_TOKEN"

destination_hostname = "tfe.example.com"
destination_organization = "your-org-tfe"
destination_token = "YOUR_TFE_TOKEN"

vcs_map = {
  "ot-HCP_OAUTH_ID" = "ot-TFE_OAUTH_ID"
}
```

### Step 3: Run Migration

```bash
tfm copy workspace \
  --source-name resource-discovery \
  --destination-name resource-discovery \
  --config ~/.tfm.hcl
```

Type `yes` when prompted.

### Step 4: Verify

Go to TFE workspace → States → Verify `aws_instance.all_0` exists.

```bash
cd terraform/aws-ec2/discovery

# Update backend to point to TFE
cat > tfe-backend.tf << 'EOF'
terraform {
  cloud {
    hostname = "tfe.example.com"
    organization = "your-org-tfe"
    workspaces {
      name = "resource-discovery"
    }
  }
}
EOF

terraform login tfe.example.com
terraform init
terraform state list  # Should show aws_instance.all_0
terraform plan        # Should show no changes
```

---

## Troubleshooting

### Phase 1: No Resources Found
```bash
cd terraform/aws-ec2/deployment
terraform output instance_id  # Verify instance exists
```

### Phase 2: Plan Shows Conflicts
- Verify you removed ALL 9 conflicting attributes
- Check `terraform/aws-ec2/discovery/README.md` for complete list

### Phase 3: VCS Not Connected
- Verify OAuth mapping in `~/.tfm.hcl`
- Get correct token IDs from HCP Terraform and TFE VCS settings

---

## Project Structure

```
terraform/
├── aws-ec2/
│   ├── deployment/           # Phase 1: Deploy EC2
│   └── discovery/            # Phase 1-2: Discovery & Import
│       ├── discovery.tfquery.hcl
│       └── generated.tf
└── hcp-terraform/            # Phase 1: Create workspace
```

---

## Resources

- [HCP Terraform Search & Import](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [TFM Migration Tool](https://github.com/hashicorp-services/tfm)
- [Terraform 1.14.0-rc2](https://releases.hashicorp.com/terraform/1.14.0-rc2/)
