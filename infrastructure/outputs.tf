output "function_app_url" {
  value = module.function_app.function_app_url
}

output "function_app_id" {
  value = module.function_app.function_app_id
}

output "static_web_app_url" {
  value = module.static_web_app.static_web_app_url
}

output "static_web_app_id" {
  value = module.static_web_app.static_web_app_id
}

output "sql_server_name" {
  value = module.sql_server.sql_server_name
}

output "sql_connection_string" {
  value = module.sql_server.sql_connection_string
  sensitive = true
}