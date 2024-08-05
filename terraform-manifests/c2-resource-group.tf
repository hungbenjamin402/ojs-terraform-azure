# Resource-1: Azure Resource
resource "azurerm_resource_group" "ojs_rg" {
  name     = "ojs-resources"
  location = "West US"
}