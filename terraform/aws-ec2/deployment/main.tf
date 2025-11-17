# ============================================
# Simple EC2 Instance (no module - simpler!)
# ============================================

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "demo" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
