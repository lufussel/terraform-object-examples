variable "vnet_name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  default     = "test-network"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "test-network-rg"
}

variable "subnets" {
    description = "The list of subnets to be created."
    type        = list(map(string))
}