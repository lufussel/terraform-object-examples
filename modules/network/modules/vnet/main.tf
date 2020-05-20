resource "azurerm_virtual_network" "network" {
  name                = var.vnet_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
  tags                = var.tags
}