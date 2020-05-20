terraform {
  required_version      = ">= 0.12"
}

provider "azurerm" {
  version = "= 2.0.0"
  features {}
}

resource "azurerm_resource_group" "network" {
    name        = "hack2-rg"
    location    = "uksouth"
    tags        = var.tags
}

module "network" {
    source              = "./modules/network"

    vnet_name           = "hack2-vnet"
    resource_group_name = azurerm_resource_group.network.name
    location            = "uksouth"
    address_space       = ["10.100.0.0/16"]
    dns_servers         = []

    subnets = [
        {
            subnet_name                         = "web"
            subnet_address_prefix               = "10.100.0.0/24"
            subnet_network_security_group_id    = module.web-nsg.network_security_group_id
        },
        {
            subnet_name                         = "app"
            subnet_address_prefix               = "10.100.1.0/24"
            subnet_network_security_group_id    = module.web-nsg.network_security_group_id
        },
        {
            subnet_name           = "domain"
            subnet_address_prefix = "10.100.2.0/24"
            subnet_network_security_group_id    = module.domain-nsg.network_security_group_id
        }
    ]

    tags                = var.tags
}

# Using a custom module for a simple ruleset

module "web-nsg" {
    source              = "./modules/custom-network-security-group"

    nsg_name            = "hack2-web-nsg"
    resource_group_name = azurerm_resource_group.network.name
    location            = "uksouth"

    rules = [
        {
            name                        = "allow-https"
            priority                    = "1000"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "443"
            description                 = "Allow HTTPS"
        },
        {
            name                        = "allow-ssh"
            priority                    = "1010"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "22"
            description                 = "Allow SSH"
        },
        {
            name                        = "allow-rdp"
            priority                    = "1020"
            protocol                    = "*"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "3389"
            description                 = "Allow RDP"
        },
        {
            name                        = "deny-all"
            priority                    = "4000"
            access                      = "Deny"
            protocol                    = "*"
            source_address_prefix       = "*"
            destination_port_ranges     = "*"
            description                 = "Deny unmatched inbound traffic"
        }
  ]

    tags                = var.tags
}

# Using the Azure NSG module from Terraform Registry

# module "network-security-group" {
#   source                = "Azure/network-security-group/azurerm"
  
#   security_group_name   = "hack2-data-nsg"
#   resource_group_name   = azurerm_resource_group.network.name

#   source_address_prefix = ["10.100.1.0/24"]

#   predefined_rules = [
#     {
#       name     = "MSSQL"
#       priority = "1000"
#     },
#     {
#       name              = "RDP"
#       priority = "1010"
#     }
#   ]
  
#   custom_rules = [
#     {
#       name                   = "example"
#       priority               = "1020"
#       direction              = "Inbound"
#       access                 = "Allow"
#       protocol               = "tcp"
#       destination_port_range = "8080"
#       description            = "Example custom rule"
#     }
#   ]

#   tags                = var.tags
# }

# Using a custom module for a complex ruleset

module "domain-nsg" {
    source              = "./modules/custom-network-security-group"

    nsg_name            = "hack2-domain-nsg"
    resource_group_name = azurerm_resource_group.network.name
    location            = "uksouth"

    rules = [
        {
            name                        = "allow-rpc"
            priority                    = "1000"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "135"
            description                 = "Allow RPC Endpoint Mapper inbound"
        },
        {
            name                        = "allow-ldap"
            priority                    = "1010"
            protocol                    = "*"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "389"
            description                 = "Allow LDAP inbound"
        },
        {
            name                        = "allow-ldap-ssl"
            priority                    = "1020"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "636"
            description                 = "Allow LDAP SSL inbound"
        },
        {
            name                        = "allow-ldap-gc"
            priority                    = "1030"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "3268"
            description                 = "Allow LDAP GC inbound"
        },
        {
            name                        = "allow-ldap-gc-ssl"
            priority                    = "1040"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "3269"
            description                 = "Allow LDAP GC SSL inbound"
        },
        {
            name                        = "allow-dns"
            priority                    = "1050"
            protocol                    = "*"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "53"
            description                 = "Allow DNS inbound"
        },
        {
            name                        = "allow-kerberos"
            priority                    = "1060"
            protocol                    = "*"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "88"
            description                 = "Allow Kerberos inbound"
        },
        {
            name                        = "allow-smb"
            priority                    = "1070"
            protocol                    = "Tcp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "445"
            description                 = "Allow SMB inbound"
        },
        {
            name                        = "allow-windowstime"
            priority                    = "1100"
            protocol                    = "Udp"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "123"
            description                 = "Allow W32Time inbound"
        },
        {
            name                        = "allow-kerberos-pc"
            priority                    = "1110"
            protocol                    = "*"
            source_address_prefix       = "VirtualNetwork"
            destination_port_ranges     = "464"
            description                 = "Allow Kerberos password change inbound"
        },
        {
            name                        = "allow-rdp"
            priority                    = "2000"
            protocol                    = "*"
            source_address_prefix       = "10.100.6.0/24"
            destination_port_ranges     = "3389"
            description                 = "Allow RDP inbound from Management"
        },
        {
            name                        = "allow-powershellremoting"
            priority                    = "2010"
            protocol                    = "*"
            source_address_prefix       = "10.100.6.0/24"
            destination_port_ranges     = "5985-5986"
            description                 = "Allow WinRM and PowerShell Remoting inbound from Management"
        },
        {
            name                        = "deny-all"
            priority                    = "4000"
            access                      = "Deny"
            protocol                    = "*"
            source_address_prefix       = "*"
            destination_port_ranges     = "*"
            description                 = "Deny unmatched inbound traffic"
        }
  ]

    tags                = var.tags
}