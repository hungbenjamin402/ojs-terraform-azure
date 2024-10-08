# custom data to booststrap the bastion host vm
locals {
bastion_host_custom_data = <<CUSTOM_DATA
#!/bin/sh
#sudo yum update -y
sudo yum -y install telnet
sudo yum -y install mysql
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo yum install -y telnet
sudo chmod -R 777 /var/www/html 
sudo echo "Welcome to stacksimplify - Bastion Host - VM Hostname: $(hostname)" > /var/www/html/index.html
CUSTOM_DATA  
}
# Creating a public IP address for bastion host vm
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${local.bastion_host}-pip"
  location            = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# resource-2: create NIC
resource "azurerm_network_interface" "bastion_host_linuxvm_nic" {
  name = "${local.bastion_host}-nic"
  location = azurerm_resource_group.ojs_rg.location
  resource_group_name = azurerm_resource_group.ojs_rg.name

  ip_configuration {
    name = "${local.bastion_host}-ip-1"
    subnet_id = module.vnet.vnet_subnets[1]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}

# resource-3: azure linux vm for bastion host
resource "azurerm_linux_virtual_machine" "bastion_host_linuxvm" {
    name = local.bastion_host
    resource_group_name = azurerm_resource_group.ojs_rg.name
    location = azurerm_resource_group.ojs_rg.location
    size = "Standard_B1s"
    admin_username = "azureuser"
    network_interface_ids = [azurerm_network_interface.bastion_host_linuxvm_nic.id]
    admin_ssh_key {
        username = "azureuser"
        public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
    }
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "83-gen2"
        version = "latest"
    }
    
    custom_data = base64encode(local.bastion_host_custom_data)  

    # depends_on = [azurerm_network_interface.bastion_host_linuxvm_nic]
}