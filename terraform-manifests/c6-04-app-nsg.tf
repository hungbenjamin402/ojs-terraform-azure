resource "azurerm_network_security_group" "app_subnet_nsg" {
  name                = "${var.app_subnet_name}-nsg"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
}

# Resource-3: Associate NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.app_nsg_rule_inbound]  
  subnet_id                 = module.vnet.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.app_subnet_nsg.id
}

# Resource-4: Create NSG Rules
## Locals Block for Security Rules
locals {
  app_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
    "120" : "8080",
    "130" : "22"
  } 
}
## NSG Inbound Rule for AppTier Subnets
resource "azurerm_network_security_rule" "app_nsg_rule_inbound" {
  for_each = local.app_inbound_ports_map
  name                        = "Port-${each.value}-rule"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ojs_rg.name
  network_security_group_name = azurerm_network_security_group.app_subnet_nsg.name
}


