# Resource-1: Create WebTier Subnet and Resource-3: Associate NSG and Subnet created w/vnet module in 

# Resource-2: Create Network Security Group (NSG)
resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${var.web_subnet_name}-nsg"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
}

# Resource-4: Create NSG Rules
## Locals Block for Security Rules
locals {
  web_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "22"
  } 
}
## NSG Inbound Rule for WebTier Subnets
resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each = local.web_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ojs_rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}


