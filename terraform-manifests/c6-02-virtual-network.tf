# Create a virtual network
resource "azurerm_virtual_network" "ojs_vnet" {
  name                = "ojs-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
}

# Create a subnet
resource "azurerm_subnet" "ojs_subnet" {
  name                 = "ojs-subnet"
  resource_group_name  = azurerm_resource_group.ojs_rg.name
  virtual_network_name = azurerm_virtual_network.ojs_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP
resource "azurerm_public_ip" "ojs_public_ip" {
  name                = "ojs-public-ip"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
  allocation_method   = "Dynamic"
}

# Create a network security group and rule
resource "azurerm_network_security_group" "ojs_nsg" {
  name                = "ojs-nsg"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create a network interface
resource "azurerm_network_interface" "ojs_nic" {
  name                = "ojs-nic"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name

  ip_configuration {
    name                          = "ojs-nic-config"
    subnet_id                     = azurerm_subnet.ojs_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ojs_public_ip.id
  }
}

