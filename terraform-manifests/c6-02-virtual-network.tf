# Vnet module to create vnet, subnets, and more
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  
  use_for_each = true # set to true because no exisiting infratructure
  vnet_location = azurerm_resource_group.ojs_rg.location

  vnet_name = var.vnet_name
  resource_group_name = azurerm_resource_group.ojs_rg.name
  address_space       = var.vnet_address_space
  subnet_prefixes     = [var.web_subnet_address[0], var.app_subnet_address[0], var.db_subnet_address[0], var.bastion_subnet_address[0]]
  # not sure why but sorted in alphabetical order (stored as app, bastion, db, web)
  subnet_names        = [var.web_subnet_name, var.app_subnet_name, var.db_subnet_name, var.bastion_subnet_name]
  
  subnet_service_endpoints = {
    "${var.db_subnet_name}" = ["Microsoft.Storage", "Microsoft.Sql"] #,
   
  }
  subnet_delegation = {
    
    "${var.db_subnet_name}"  = {
      "Microsoft.Sql.managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      } 
    },  
    "${var.db_subnet_name}" = {
      "Microsoft.DBforMySQL/flexibleServers" = {
        service_name = "Microsoft.DBforMySQL/flexibleServers"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }

  nsg_ids = {
    "${var.web_subnet_name}" = "${azurerm_network_security_group.web_subnet_nsg.id}"
    "${var.bastion_subnet_name}" = "${azurerm_network_security_group.bastion_subnet_nsg.id}"
    "${var.db_subnet_name}" = "${azurerm_network_security_group.db_subnet_nsg.id}"

  }
  tags = {
    environment = "${local.environment}"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.ojs_rg]   
  
}

# if you need internet fronting for ojs vm, then uncomment the code below
# # Create a public IP
# resource "azurerm_public_ip" "ojs_public_ip" {
#   name                = "ojs-public-ip"
#   location            = azurerm_resource_group.ojs_rg.location
#   resource_group_name = azurerm_resource_group.ojs_rg.name
#   allocation_method   = "Dynamic"
# }

resource "azurerm_network_interface" "ojs_nic" {
  name                = "ojs-nic"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name

  ip_configuration {
    name                          = "ojs-nic-config"
    #might need to update index if adding more subnets bc alphabetical
    subnet_id                     = module.vnet.vnet_subnets[3]
    private_ip_address_allocation = "Dynamic"
    # uncomment the following code to allow public ip assocaition to nic
    # public_ip_address_id          = azurerm_public_ip.ojs_public_ip.id
  }
}

