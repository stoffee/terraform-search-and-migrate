# ============================================
# CLEANUP: Old/Orphaned AWS Resources
# ============================================
# This file contains resources to be DESTROYED
# Run: terraform destroy -target=module.cleanup
# 
# EXCLUDED (DO NOT DELETE):
# - Default VPC: vpc-010ccb9aa591de2ea
# - HCP Peering roles (2)
# - TFC Workload Identity roles (2)
# - All Doormat, Honeybee, Security roles
# - AWS-managed KMS keys/aliases

# ============================================
# OLD EKS CLUSTER ROLES (13 roles from 2022-2023)
# ============================================

resource "aws_iam_role" "cleanup_eksctl_test_consul" {
  name = "eksctl-test-consul-eks-cluster-ServiceRole-WT537Q0Z108H"
  # This will be destroyed
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_eks_hcp_vault_1" {
  name = "eks-hcp-vault-eks20230118203021572700000003"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_eks_hcp_vault_2" {
  name = "eks-hcp-vault-eks2023011820385197020000000b"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_eks_hcp_vault_3" {
  name = "eks-hcp-vault-eks20230118210051248400000002"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_fast_fish" {
  name = "fast-fish-cluster-cluster-20230207220616885600000002"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_layout_stoffee" {
  name = "layout-stoffee-io-cluster20230125210723306700000003"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_rocket_eks" {
  name = "rocket-eks-cluster-20230531011545625800000001"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_ubettawerk" {
  name = "ubettawerk-eks-node-group-20230207220616883700000001"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_default_fargate" {
  name = "default-20221101203237565100000006"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_default_node_group" {
  name = "default-eks-node-group-20251113192615891900000001"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "cleanup_node_group_01" {
  name = "node_group_01-eks-node-group-20230531011545626100000002"
  lifecycle {
    prevent_destroy = false
  }
}

# ============================================
# VAULT DEMO RESOURCES
# ============================================

resource "aws_iam_role" "cleanup_vault_demo" {
  name = "vault-assumed-role-credentials-demo"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "cleanup_demo_user" {
  name = "DemoUser"
  lifecycle {
    prevent_destroy = false
  }
}

# ============================================
# RDS MONITORING (if not using RDS)
# ============================================

resource "aws_iam_role" "cleanup_rds_monitoring" {
  name = "rds-monitoring-role"
  lifecycle {
    prevent_destroy = false
  }
}

# ============================================
# ORPHANED SEARCH-IMPORT-DEMO-EKS RESOURCES
# ============================================

resource "aws_vpc" "cleanup_demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "search-import-demo-eks-vpc"
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_security_group" "cleanup_demo_default_sg" {
  name        = "default"
  description = "default VPC security group"
  vpc_id      = aws_vpc.cleanup_demo_vpc.id
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_security_group" "cleanup_demo_cluster_sg" {
  name_prefix = "search-import-demo-eks-cluster-"
  description = "EKS cluster security group"
  vpc_id      = aws_vpc.cleanup_demo_vpc.id
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_security_group" "cleanup_demo_node_sg" {
  name_prefix = "search-import-demo-eks-node-"
  description = "EKS node shared security group"
  vpc_id      = aws_vpc.cleanup_demo_vpc.id
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_key" "cleanup_demo_kms" {
  description             = "search-import-demo-eks cluster encryption key"
  deletion_window_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "cleanup_demo_encryption" {
  name = "search-import-demo-eks-cluster-ClusterEncryption20251113192637001600000008"
  lifecycle {
    prevent_destroy = false
  }
}

# ============================================
# OLD EKS CLOUDWATCH LOG GROUPS
# ============================================

resource "aws_cloudwatch_log_group" "cleanup_cdunlap_primary" {
  name = "/aws/eks/cdunlap-primary-eks-dc/cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cleanup_fast_fish_logs" {
  name = "/aws/eks/fast-fish-cluster/cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cleanup_happy_dinosaur" {
  name = "/aws/eks/happy-classical-dinosaur/cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cleanup_proper_ape" {
  name = "/aws/eks/proper-ape/cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cleanup_rocket_logs" {
  name = "/aws/eks/rocket-eks/cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "cleanup_rds_metrics" {
  name = "RDSOSMetrics"
  lifecycle {
    prevent_destroy = false
  }
}

# ============================================
# OLD EKS KMS KEYS
# ============================================

resource "aws_kms_key" "cleanup_cdunlap_primary_kms" {
  description             = "cdunlap-primary-eks-dc cluster encryption key"
  deletion_window_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_key" "cleanup_rocket_kms" {
  description             = "rocket-eks cluster encryption key"
  deletion_window_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_key" "cleanup_fast_fish_kms" {
  description             = "fast-fish-cluster cluster encryption key"
  deletion_window_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "cleanup_fast_fish_alias" {
  name          = "alias/eks/fast-fish-cluster"
  target_key_id = aws_kms_key.cleanup_fast_fish_kms.key_id
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "cleanup_rocket_alias" {
  name          = "alias/eks/rocket-eks"
  target_key_id = aws_kms_key.cleanup_rocket_kms.key_id
  lifecycle {
    prevent_destroy = false
  }
}
