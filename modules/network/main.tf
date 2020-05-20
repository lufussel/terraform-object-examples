terraform {
  required_version          = ">= 0.12"
}

provider "azurerm" {
  version = "= 2.0.0"
  features {}
}

module "vnet" {
  source                    = "./modules/vnet"
  vnet_name                 = var.vnet_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  address_space             = var.address_space
  dns_servers               = var.dns_servers
  tags                      = var.tags
}

module "subnets" {
  source                    = "./modules/subnets"
  vnet_name                 = module.vnet.vnet_name
  resource_group_name       = module.vnet.resource_group_name
  subnets                   = var.subnets
}
