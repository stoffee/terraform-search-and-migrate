output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.demo.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.demo.id
}

output "public_ip_address" {
  description = "The allocated public IP address"
  value       = azurerm_public_ip.demo.ip_address
}

output "public_ip_id" {
  description = "ID of the created public IP"
  value       = azurerm_public_ip.demo.id
}
