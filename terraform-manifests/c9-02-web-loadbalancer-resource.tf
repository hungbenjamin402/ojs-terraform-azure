# resource 1: create public for loadbalancer
resource "azurerm_public_ip" "web_lbpublicip" {
  name = "${local.environment}-lbpip"
  resource_group_name = azurerm_resource_group.ojs_rg.name
  location = azurerm_resource_group.ojs_rg.location
  allocation_method = "Static"
  sku = "Standard"
  tags = local.common_tags
}
# resource 2: create standard load balancer in azure
resource "azurerm_lb" "web_lb" {
  name = "${local.environment}-web-lb"
  resource_group_name = azurerm_resource_group.ojs_rg.name 
  location = azurerm_resource_group.ojs_rg.location  
  sku = "Standard"
  frontend_ip_configuration {
    name = "web-lb-publicip-1"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip.id
  }
}
# resource 3: backend pool 
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id

}

# resource 4: lb probe
resource "azurerm_lb_probe" "web_lb_probe" {
  name = "tcp-probe"
  protocol = "Tcp"
  port = 80
  loadbalancer_id = azurerm_lb.web_lb.id
  # resource_group_name = azurerm_resource_group.rg.name 
}
# resource 5: lb rule creation
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name = "web-app1-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id]
  probe_id = azurerm_lb_probe.web_lb_probe.id 
  loadbalancer_id = azurerm_lb.web_lb.id
  # resource_group_name = azurerm_resource_group.rg.name 
}
# resource 6: NIC and lb association
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id = azurerm_network_interface.ojs_nic.id 
  ip_configuration_name = azurerm_network_interface.ojs_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id   
}