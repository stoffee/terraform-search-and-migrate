# Simple EC2 Deployment

This deploys minimal resources for testing Search & Import:
- 1 EC2 instance (t3.micro)

## Quick Start

1. **Copy the example tfvars**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars**:
   - Example: `search-import-demo-bucket-12345`

3. **Set AWS credentials**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"
   export AWS_SESSION_TOKEN="your-token"  # if using temporary credentials
   ```

4. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

**Duration**: ~30 seconds (much faster than EKS!)

5. **Save resource info**:
   ```bash
   terraform output -json > deployed-resources.json
   ```

## What Gets Created

**EC2 Instance**:
- Amazon Linux 2023
- t3.micro (free tier eligible)
- Tagged with Name, Environment, Project

## For Search & Import Testing

After deployment:
- **Keep the state file** - don't delete it
- Just don't run `terraform destroy`
- Resources are ready to be discovered by Search & Import

## Cleanup

When done testing:
```bash
terraform destroy
```

This is why we keep the state file - easy cleanup!
