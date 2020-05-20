variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "uksouth"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map

  default = {
    application = "terraform-hack-test"
    environment = "development"
    buildagent = "local"
  }
}

# --------------------------------------------------------
# Properties for the network
# --------------------------------------------------------

variable "vnet_name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  default     = "test-network"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "test-network-rg"
}

variable "address_space" {
  description = "The address space that is used for the virtual network. You can supply more than one address space."
  default     = ["10.100.0.0/16"]
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers. If no values specified, this defaults to Azure DNS."
  default     = []
}

variable "subnets" {
  description = "List of IP addresses of DNS servers. If no values specified, this defaults to Azure DNS."
  default     = [
        {
            subnet_name           = "subnet1"
            subnet_address_prefix = "10.100.0.0/24"
        }
    ]
}