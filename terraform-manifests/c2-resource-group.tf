# Resource-1: Azure Resource
# resource "azurerm_resource_group" "ojs_rg" {
#   name     = "ojs-resources"
#   location = "West US"
# }

resource "azurerm_resource_group" "ojs_rg" {
  name     = "${local.environment}-${var.resource_group_name}-${random_string.myrandom.id}"
  location = var.resource_group_location
  tags = local.common_tags
}