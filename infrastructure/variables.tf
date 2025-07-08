variable "resource_group_name" {
  description = "The name of the resource group where the infrastructure will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

variable "function_app_name" {
  description = "The name of the Azure Function App."
  type        = string
}

variable "static_web_app_name" {
  description = "The name of the Azure Static Web App."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the Azure SQL Server."
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for the SQL Server."
  type        = string
}

variable "sql_admin_password" {
  description = "The administrator password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the database."
  type        = string
}

variable "app_location" {
  description = "The location of the app source code"
  type        = string
  default     = "/"
}

variable "api_location" {
  description = "The location of the API source code"
  type        = string
  default     = ""
}

variable "function_app_storage_account_name" {
  description = "The name of the storage account for the Function App."
  type        = string
}

variable "function_app_plan_name" {
  description = "The name of the App Service Plan for the Function App."
  type        = string
}

variable "static_web_app_location" {
  description = "The location for the static web app build output."
  type        = string
}

variable "app_insights_name" {
  description = "The name of the Application Insights resource."
  type        = string
  default     = ""
}

variable "runtime_stack" {
  description = "The runtime stack for the Function App."
  type        = string
  default     = "dotnet"
}

variable "output_location" {
  description = "The output location for the static web app."
  type        = string
  default     = "out"
}