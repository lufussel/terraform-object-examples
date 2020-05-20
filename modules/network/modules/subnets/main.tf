locals {
  subnets = {
    for x in var.subnets :
    x.subnet_name => x
  }
}

resource "azurerm_subnet" "subnet" {
    for_each                    = local.subnets
    name                        = each.value.subnet_name
    virtual_network_name        = var.vnet_name
    resource_group_name         = var.resource_group_name
    address_prefix              = each.value.subnet_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
    for_each                    = local.subnets
    subnet_id                   = azurerm_subnet.subnet[each.key].id
    network_security_group_id   = each.value.subnet_network_security_group_id
}
