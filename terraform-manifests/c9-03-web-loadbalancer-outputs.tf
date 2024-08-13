# LB PIP
output "web_lb_pip_address" {
  description = "Public IP of Web load balancer"
  value = azurerm_public_ip.web_lbpublicip.ip_address
}

# LB ID
output "web_lb_id" {
  description = "Id of web lb"
  value = azurerm_lb.web_lb.id 
}

# LB frontend ip block
output "web_lb_frontend_ip_configuration" {
  description = "Web LB frontend_ip_configuration Block"
  value = [azurerm_lb.web_lb.frontend_ip_configuration]
}