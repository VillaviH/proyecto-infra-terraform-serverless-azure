output "function_app_url" {
  value = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_id" {
  value = azurerm_linux_function_app.function_app.id
}