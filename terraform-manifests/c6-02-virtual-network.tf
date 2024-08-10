# # Create a virtual network
# resource "azurerm_virtual_network" "ojs_vnet" {
#   name                = "ojs-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.ojs_rg.location
#   resource_group_name = azurerm_resource_group.ojs_rg.name
# }

# # Create a subnet
# resource "azurerm_subnet" "ojs_subnet" {
#   name                 = "ojs-subnet"
#   resource_group_name  = azurerm_resource_group.ojs_rg.name
#   virtual_network_name = azurerm_virtual_network.ojs_vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  
  use_for_each = true # set to true because no exisiting infratructure
  vnet_location = azurerm_resource_group.ojs_rg.location

  vnet_name = var.vnet_name
  resource_group_name = azurerm_resource_group.ojs_rg.name
  address_space       = var.vnet_address_space
  subnet_prefixes     = [var.web_subnet_address[0], var.app_subnet_address[0], var.db_subnet_address[0], var.bastion_subnet_address[0]]
  # not sure why but sorted in alphabetical order
  subnet_names        = [var.web_subnet_name, var.app_subnet_name, var.db_subnet_name, var.bastion_subnet_name]
  subnet_service_endpoints = {
    "${var.db_subnet_name}" = ["Microsoft.Storage", "Microsoft.Sql"] #,
   
  }

  nsg_ids = {
    "${var.web_subnet_name}" = "${azurerm_network_security_group.app_subnet_nsg.id}"
    "${var.bastion_subnet_name}" = "${azurerm_network_security_group.bastion_subnet_nsg.id}"
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

# Create a network security group and rule
# resource "azurerm_network_security_group" "ojs_nsg" {
#   name                = "ojs-nsg"
#   location            = azurerm_resource_group.ojs_rg.location
#   resource_group_name = azurerm_resource_group.ojs_rg.name

#   security_rule {
#     name                       = "HTTP"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# Create a network interface
# resource "azurerm_network_interface" "ojs_nic" {
#   name                = "ojs-nic"
#   location            = azurerm_resource_group.ojs_rg.location
#   resource_group_name = azurerm_resource_group.ojs_rg.name

#   ip_configuration {
#     name                          = "ojs-nic-config"
#     subnet_id                     = azurerm_subnet.ojs_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.ojs_public_ip.id
#   }
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

