# Discovery configuration for HCP Terraform Search & Import
# For demo purposes, we only discover the EC2 instance we deployed

list "aws_instance" "all" {
  provider = aws
}