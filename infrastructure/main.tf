resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "sql_server" {
  source              = "./modules/sql_server"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  sql_server_name    = var.sql_server_name
  administrator_login     = var.sql_admin_username
  administrator_login_password     = var.sql_admin_password
  database_name      = var.database_name
}

module "function_app" {
  source              = "./modules/function_app"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  function_app_name  = var.function_app_name
  storage_account_name = var.function_app_storage_account_name
  app_insights_name = var.app_insights_name
  runtime_stack = var.runtime_stack
}

module "static_web_app" {
  source              = "./modules/static_web_app"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  static_web_app_name = var.static_web_app_name
  app_location       = var.app_location
  api_location       = var.api_location
  output_location    = var.output_location
}