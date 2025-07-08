resource "azurerm_storage_account" "function_app_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "function_app_service_plan" {
  name                = "${var.function_app_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.function_app_service_plan.id
  storage_account_name       = azurerm_storage_account.function_app_storage.name
  storage_account_access_key = azurerm_storage_account.function_app_storage.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = var.functions_worker_runtime
    "AzureWebJobsStorage"      = azurerm_storage_account.function_app_storage.primary_connection_string
  }
}