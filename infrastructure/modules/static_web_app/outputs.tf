output "static_web_app_url" {
  value = azurerm_static_web_app.static_web_app.default_host_name
}

output "static_web_app_id" {
  value = azurerm_static_web_app.static_web_app.id
}