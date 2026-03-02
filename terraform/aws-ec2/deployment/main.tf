# ============================================
# Simple EC2 Instance (no module - simpler!)
# ============================================

# HC-approved base AMI with EDR (HC-COMPUTE-011)
module "base_ami" {
  source  = "app.terraform.io/cdunlap/hc-base-ami/aws"
  version = "1.0.0"

  os_flavor    = "rhel-9"
  architecture = "x86_64"
}

resource "aws_instance" "demo" {
  ami           = module.base_ami.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    TTL         = "72"
    NAME        = "cdunlap"
    DEMO        = "terraform search and import"
    CUSTOMER    = "tmobile"
  }
}
