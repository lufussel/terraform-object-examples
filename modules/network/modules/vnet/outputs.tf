output "vnet_id" {
  description = "The id of the resource."
  value       = azurerm_virtual_network.network.id
}

output "vnet_name" {
  description = "The name of the resource."
  value       = azurerm_virtual_network.network.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the resource was created."
  value       = azurerm_virtual_network.network.resource_group_name
}

output "vnet_location" {
  description = "The location of the resource."
  value       = azurerm_virtual_network.network.location
}

output "vnet_address_space" {
  description = "The address space of the resource."
  value       = azurerm_virtual_network.network.address_space
}
