# Resource-1: Azure MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "ojs_server" {
  #name                   = "ojs-mysqlserver"
  name = "${local.environment}-${var.mysql_db_name}-server-${random_string.myrandom.id}"
  resource_group_name    = azurerm_resource_group.ojs_rg.name
  location               = azurerm_resource_group.ojs_rg.location
  administrator_login    = var.mysql_db_username
  administrator_password = var.mysql_db_password
  sku_name               = "B_Standard_B4ms"
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  delegated_subnet_id = module.vnet.vnet_subnets[2]
}

# Resource-2: Azure MySQL Database / Schema
resource "azurerm_mysql_flexible_database" "ojs_db" {
  name                = "ojsdb"
  resource_group_name = azurerm_resource_group.ojs_rg.name
  server_name         = azurerm_mysql_flexible_server.ojs_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Resource-3: Azure MySQL Flexible Server Firewall Rule
resource "azurerm_mysql_flexible_server_firewall_rule" "ojs_fw_rule" {
  name                = "AllowAllAzureIPs"
  resource_group_name = azurerm_resource_group.ojs_rg.name
  server_name         = azurerm_mysql_flexible_server.ojs_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_mysql_flexible_server_configuration" "ojs_server_ssl_config" {
  resource_group_name = azurerm_resource_group.ojs_rg.name
  server_name = azurerm_mysql_flexible_server.ojs_server.name
  name      = "require_secure_transport"
  value     = "off"
}