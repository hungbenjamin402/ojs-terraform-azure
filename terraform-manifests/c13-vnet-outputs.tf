# Output Values - Virtual Network
# virtual_network_name
output "virtual_network_name" {
  description = "Virtual Network Name"
  value = module.vnet.vnet_name
}
# virtual_network_id
output "virtual_network_id" {
  description = "Virtual Network ID"
  value = module.vnet.vnet_id
}
# virtual_network_subnets
output "virtual_network_subnets" {
  description = "Virtual Network Subnets"
  value = module.vnet.vnet_subnets
}  
# virtual_network_location
output "virtual_network_location" {
  description = "Virtual Network Location"
  value = module.vnet.vnet_location
}  
# virtual_network_address_space
output "virtual_network_address_space" {
  description = "Virtual Network Address Space"
  value = module.vnet.vnet_address_space
}  

# Network Security Outputs
## Web Subnet NSG Name 
output "web_subnet_nsg_name" {
  description = "WebTier Subnet NSG Name"
  value = azurerm_network_security_group.web_subnet_nsg.name
}

## Web Subnet NSG ID 
output "web_subnet_nsg_id" {
  description = "WebTier Subnet NSG ID"
  value = azurerm_network_security_group.web_subnet_nsg.id
}


