# ============================================
# Discovery Configuration for Azure Resources
# ============================================
# Used by HCP Terraform Search & Import to discover
# unmanaged Azure resources in your subscription.
#
# Confirmed list resource types as of AzureRM Provider 4.73+
# See: https://github.com/hashicorp/terraform-provider-azurerm/blob/main/CHANGELOG.md

# ============================================
# MANAGEMENT
# ============================================

# Resource Groups (4.58.0+)
list "azurerm_resource_group" "all" {
  provider = azurerm
}

# ============================================
# NETWORKING
# ============================================

# Public IP Addresses (4.61.0+)
list "azurerm_public_ip" "all" {
  provider = azurerm
}

# Application Gateways (4.61.0+)
list "azurerm_application_gateway" "all" {
  provider = azurerm
}

# Application Security Groups (4.61.0+)
list "azurerm_application_security_group" "all" {
  provider = azurerm
}

# Azure Firewalls (4.61.0+)
list "azurerm_firewall" "all" {
  provider = azurerm
}

# Firewall Policies (4.61.0+)
list "azurerm_firewall_policy" "all" {
  provider = azurerm
}

# IP Groups (4.61.0+)
list "azurerm_ip_group" "all" {
  provider = azurerm
}

# NAT Gateways (4.61.0+)
list "azurerm_nat_gateway" "all" {
  provider = azurerm
}

# Network Security Rules (4.61.0+)
list "azurerm_network_security_rule" "all" {
  provider = azurerm
}

# Web Application Firewall Policies (4.61.0+)
list "azurerm_web_application_firewall_policy" "all" {
  provider = azurerm
}

# DDoS Protection Plans (4.62.0+)
list "azurerm_network_ddos_protection_plan" "all" {
  provider = azurerm
}

# Private Endpoints (4.62.0+)
list "azurerm_private_endpoint" "all" {
  provider = azurerm
}

# Private DNS A Records (4.62.0+)
list "azurerm_private_dns_a_record" "all" {
  provider = azurerm
}

# Routes (4.62.0+)
list "azurerm_route" "all" {
  provider = azurerm
}

# Subnets (4.72.0+)
list "azurerm_subnet" "all" {
  provider = azurerm
}

# Private DNS CNAME Records (4.68.0+)
list "azurerm_private_dns_cname_record" "all" {
  provider = azurerm
}

# Traffic Manager Profiles (4.69.0+)
list "azurerm_traffic_manager_profile" "all" {
  provider = azurerm
}

# ============================================
# DATABASE
# ============================================

# Azure SQL Servers (4.61.0+)
list "azurerm_mssql_server" "all" {
  provider = azurerm
}

# Azure SQL Databases (4.61.0+)
list "azurerm_mssql_database" "all" {
  provider = azurerm
}

# SQL Elastic Pools (4.62.0+)
list "azurerm_mssql_elasticpool" "all" {
  provider = azurerm
}

# MySQL Flexible Server Databases (4.60.0+)
list "azurerm_mysql_flexible_database" "all" {
  provider = azurerm
}

# ============================================
# CACHE
# ============================================

# Azure Cache for Redis (4.62.0+)
list "azurerm_redis_cache" "all" {
  provider = azurerm
}

# ============================================
# COMPUTE & APP
# ============================================

# App Service Plans (4.60.0+)
list "azurerm_service_plan" "all" {
  provider = azurerm
}

# ============================================
# STORAGE
# ============================================

# Storage Account Customer-Managed Keys (4.64.0+)
list "azurerm_storage_account_customer_managed_key" "all" {
  provider = azurerm
}

# Storage Sync (4.67.0+)
list "azurerm_storage_sync" "all" {
  provider = azurerm
}

# Storage Mover (4.70.0+)
list "azurerm_storage_mover" "all" {
  provider = azurerm
}

# ============================================
# AI & COGNITIVE
# ============================================

# Azure Cognitive Services (4.60.0+)
list "azurerm_cognitive_account" "all" {
  provider = azurerm
}

# Web PubSub (4.69.0+)
list "azurerm_web_pubsub" "all" {
  provider = azurerm
}
