resource "azurerm_network_security_group" "db_subnet_nsg" {
  name                = "${var.db_subnet_name}-nsg"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
}

# Resource-4: Create NSG Rules
## Locals Block for Security Rules
locals {
  db_inbound_ports_map = {
    "100" : "3306", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "1433",
    "120" : "5432"
  } 
}
## NSG Inbound Rule for DBTier Subnets
resource "azurerm_network_security_rule" "db_nsg_rule_inbound" {
  for_each = local.db_inbound_ports_map
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
  network_security_group_name = azurerm_network_security_group.db_subnet_nsg.name
}


