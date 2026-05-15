# HCP Terraform Search & Import to Terraform Enterprise Migration

Complete workflow for discovering cloud resources, importing to Terraform state, and migrating to Terraform Enterprise.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Phase 1: Resource Discovery](#phase-1-resource-discovery)
- [Phase 2: Import Resources](#phase-2-import-resources)
- [Phase 3: Migrate to TFE](#phase-3-migrate-to-tfe)

---

## Prerequisites

**Required Access**:
- AWS account (EC2 permissions) **and/or** Azure subscription (Contributor role)
- HCP Terraform account (app.terraform.io)
- Terraform Enterprise instance
- GitHub account

**Required Tools**:
- Git
- Go 1.19+ (for Phase 3)
- Terraform 1.14.0+

**Supported Cloud Providers**:

| Provider | Status | Demo Resources |
|----------|--------|---------------|
| AWS (`hashicorp/aws` 6.45+) | ✅ Full support | EC2 instance discovery |
| Azure (`hashicorp/azurerm` 4.73+) | ✅ Growing support | Resource Group + Public IP discovery |
| GCP (`hashicorp/google` 7.29+) | ⚠️ Early support | Service Account discovery |

**AWS Resources** (as of `hashicorp/aws` 6.45+):
- Compute: `aws_instance`, `aws_ebs_volume`, `aws_lambda_function`, `aws_lambda_permission`, `aws_lambda_event_source_mapping`, `aws_eks_cluster`
- Networking: `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_nat_gateway`, `aws_eip`, `aws_route_table`, `aws_route`, `aws_security_group`, `aws_vpc_security_group_ingress_rule`, `aws_vpc_security_group_egress_rule`, `aws_vpc_endpoint`, `aws_vpc_endpoint_route_table_association`, `aws_lb`, `aws_lb_target_group`, `aws_lb_target_group_attachment`, `aws_lb_listener`, `aws_route53_zone`, `aws_cloudfront_distribution`
- IAM: `aws_iam_role`, `aws_iam_user`, `aws_iam_policy`, `aws_iam_role_policy_attachment`, `aws_iam_user_policy_attachment`, `aws_iam_group_policy_attachment`, `aws_ssoadmin_account_assignment`
- Storage: `aws_s3_bucket`, `aws_s3_directory_bucket`, `aws_s3_bucket_versioning`, `aws_s3_bucket_lifecycle_configuration`, `aws_s3_bucket_logging`, `aws_s3_bucket_ownership_controls`, `aws_s3files_file_system`, `aws_s3files_access_point`
- Database: `aws_db_instance`, `aws_dynamodb_table`
- Secrets & SSM: `aws_secretsmanager_secret`, `aws_ssm_document`, `aws_ssm_association`, `aws_ssm_patch_group`
- Messaging: `aws_sns_topic`, `aws_sns_topic_policy`, `aws_sqs_queue`, `aws_sqs_queue_policy`, `aws_msk_cluster`
- Monitoring: `aws_cloudwatch_log_group`, `aws_cloudwatch_metric_alarm`, `aws_cloudwatch_log_metric_filter`
- Security: `aws_kms_key`, `aws_kms_alias`, `aws_config_config_rule`
- API: `aws_apigatewayv2_api`

**Azure Resources** (as of `hashicorp/azurerm` 4.73+):
- Management: `azurerm_resource_group`
- Networking: `azurerm_application_gateway`, `azurerm_application_security_group`, `azurerm_firewall`, `azurerm_firewall_policy`, `azurerm_firewall_policy_rule_collection_group`, `azurerm_ip_group`, `azurerm_nat_gateway`, `azurerm_network_security_rule`, `azurerm_public_ip`, `azurerm_web_application_firewall_policy`, `azurerm_network_ddos_protection_plan`, `azurerm_private_dns_a_record`, `azurerm_private_dns_cname_record`, `azurerm_private_endpoint`, `azurerm_route`, `azurerm_subnet`, `azurerm_traffic_manager_profile`
- Database: `azurerm_mssql_server`, `azurerm_mssql_database`, `azurerm_mssql_elasticpool`, `azurerm_mssql_job_agent`, `azurerm_mssql_virtual_machine`, `azurerm_mysql_flexible_database`, `azurerm_mysql_flexible_server_configuration`, `azurerm_mysql_flexible_server_firewall_rule`
- Cache: `azurerm_redis_cache`, `azurerm_redis_firewall_rule`
- Storage: `azurerm_storage_account_customer_managed_key`, `azurerm_storage_sync`, `azurerm_storage_mover`, `azurerm_storage_mover_agent`, `azurerm_storage_mover_source_endpoint`, `azurerm_storage_mover_project`, `azurerm_storage_mover_job_definition`
- Compute & App: `azurerm_service_plan`
- AI & Cognitive: `azurerm_cognitive_account`, `azurerm_web_pubsub`, `azurerm_video_indexer_account`

**GCP Resources** (as of `hashicorp/google` 7.29+):
- IAM: `google_service_account`
- More resource types expected as provider support matures

---

## Phase 1: Resource Discovery

### Step 1: Deploy EC2 Instance

```bash
cd terraform/aws/deployment
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
cd ../aws/discovery
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
cd terraform/aws/discovery
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
cd terraform/aws/discovery

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

## Project Structure

```
docs/
├── 01-search.md              # How to use Search & Import with AWS
├── azure-01-search.md        # How to use Search & Import with Azure
├── 02-import.md              # How to import discovered resources
└── 03-migrate.md             # How to migrate workspaces to TFE

terraform/
├── aws/
│   ├── deployment/           # Deploy EC2 instance (AWS demo)
│   └── discovery/            # AWS discovery config (54 resource types)
├── azurerm/
│   ├── deployment/           # Deploy Resource Group + Public IP (Azure demo)
│   └── discovery/            # Azure discovery config (39 resource types)
├── google/
│   └── discovery/            # GCP discovery config (1 resource type, growing)
└── hcp-terraform/            # Create HCP Terraform workspace (multi-cloud)
```

---

## Resources

- [HCP Terraform Search & Import](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/import)
- [TFM Migration Tool](https://github.com/hashicorp-services/tfm)
- [AWS Provider CHANGELOG](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md)
- [AzureRM Provider CHANGELOG](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG.md)
- [Google Provider CHANGELOG](https://github.com/hashicorp/terraform-provider-google/blob/main/CHANGELOG.md)
- [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads)
