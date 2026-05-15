# ============================================
# Azure Resource Group + Public IP (demo)
# ============================================

resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Name        = var.resource_group_name
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Demo        = "terraform search and import"
  }
}

# Public IP - simple discoverable resource for Search & Import demo
resource "azurerm_public_ip" "demo" {
  name                = "${var.resource_group_name}-pip"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Name        = "${var.resource_group_name}-pip"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Demo        = "terraform search and import"
  }
}
